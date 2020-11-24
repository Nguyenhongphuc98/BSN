//
//  PostController.swift
//  
//
//  Created by Phucnh on 10/18/20.
//

import Vapor
import Fluent
import SQLKit

struct PostController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let posts = routes.grouped("api" ,"v1", "posts")
        let authen = posts.grouped(Account.authenticator())
        authen.get(use: index)
        authen.post(use: create)
        authen.group(":postID") { gr in
            gr.delete(use: delete)
        }
        
        authen.get("newest", use: getNewest)
    }

    func index(req: Request) throws -> EventLoopFuture<[Post]> {
        return Post.query(on: req.db).all()
    }

    func create(req: Request) throws -> EventLoopFuture<Post> {
        let post = try req.content.decode(Post.self)
        return post.save(on: req.db).map { post }
    }

    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        
        guard let pidStr = req.parameters.get("postID"), let pid = UUID(uuidString: pidStr) else {
            throw Abort(.badRequest)
        }
        
        // Authen
        let account = try req.auth.require(Account.self)
        
        // Determine current user
        return User.query(on: req.db)
            .filter(\.$accountID == account.id!)
            .first()
            .unwrap(or: Abort(.notFound))
            .flatMap { (user)  in
                
                return Post
                    .query(on: req.db)
                    .filter(\.$id == pid)
                    .filter(\.$authorID == user.id!)
                    .first()
                    .unwrap(or: Abort(.notFound))
                    .flatMap { $0.delete(on: req.db) }
                    .transform(to: .ok)
            }
    }
    
    func getNewest(req: Request) throws -> EventLoopFuture<[Post.GetFull]> {
        
        guard let page: Int = req.query["page"] else {
            throw Abort(.badRequest)
        }
        
        var per = BusinessConfig.newestPostLimit
        if let p: Int = req.query["per"] {
            per = p
        }
        
        let offset = page * per
        
        // Get post by page, sort by create time
        // This post have category in catefories current user interest
        // Or post create by user who was followed by current user
        
        // Authen
        let account = try req.auth.require(Account.self)
        
        // Determine current user
        return User.query(on: req.db)
            .filter(\.$accountID == account.id!)
            .first()
            .unwrap(or: Abort(.notFound))
            .flatMap { (user)  in
                
                let sqlQuery = SQLQueryString("SELECT p.id, p.category_id as \"categoryID\", p.author_id as \"authorID\", p.quote, p.content, p.photo, p.num_heart as \"numHeart\", p.num_break_heart as \"numBreakHeart\", p.num_comment as \"numComment\", p.created_at as \"createdAt\", u.displayname as \"authorName\", u.avatar as \"authorPhoto\", c.name as \"categoryName\" FROM post as p, public.user as u, category as c WHERE p.category_id = c.id and p.author_id = u.id and ((p.category_id in (SELECT category_id FROM user_category where user_id = '\(raw: user.id!.uuidString)')) or (p.author_id in (SELECT user_id FROM user_follow where follower_id ='\(raw: user.id!.uuidString)')) or (p.author_id = '\(raw: user.id!.uuidString)')) order by p.created_at desc limit \(raw: per.description) offset \(raw: offset.description)")
                
                let db = req.db as! SQLDatabase
                return db.raw(sqlQuery)
                    .all(decoding: Post.GetFull.self)
            }
    }
}
