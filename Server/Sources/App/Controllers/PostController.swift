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
        authen.group(":id") { gr in
            gr.delete(use: delete)
        }
        
        authen.get("newest", use: getNewest)
        authen.get("detail", ":id", use: getPostByID)
    }

    func index(req: Request) throws -> EventLoopFuture<[Post]> {
        return Post.query(on: req.db).all()
    }

    func create(req: Request) throws -> EventLoopFuture<Post> {
        let post = try req.content.decode(Post.self)
        return post.save(on: req.db).map { post }
    }

    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        
        guard let pidStr = req.parameters.get("id"), let pid = UUID(uuidString: pidStr) else {
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
    
    func getPostByID(req: Request) throws -> EventLoopFuture<Post.GetFull> {
        
        guard let pid = req.parameters.get("id") else {
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
                
                let postQuery = SQLQueryString("SELECT p.id, p.category_id as \"categoryID\", p.author_id as \"authorID\", p.quote, p.content, p.photo, p.num_heart as \"numHeart\", p.num_break_heart as \"numBreakHeart\", p.num_comment as \"numComment\", p.created_at as \"createdAt\", u.displayname as \"authorName\", u.avatar as \"authorPhoto\", c.name as \"categoryName\" FROM post as p, public.user as u, category as c WHERE p.category_id = c.id and p.author_id = u.id and p.id = '\(raw: pid)'")
                
                let reactQuery = SQLQueryString("SELECT r.id, r.is_heart as \"isHeart\", r.user_id as \"userID\", r.post_id as \"postID\" FROM reaction as r WHERE r.user_id = '\(raw: user.id!.uuidString)' and r.post_id = '\(raw: pid)'")
                
                let db = req.db as! SQLDatabase
                
                let post = db.raw(postQuery)
                    .first(decoding: Post.GetFull.self)
                    .unwrap(or: Abort(.notFound))
                
                let react = db.raw(reactQuery)
                    .first(decoding: Reaction.Get.self)
                // for some reason, canot access field of origin class 'Reaction'
                
                return post.and(react).map { (p, r) -> (Post.GetFull) in
                    if r != nil {
                        
                        return Post.GetFull(id: p.id, categoryID: p.categoryID, authorID: p.authorID, quote: p.quote, content: p.content, photo: p.photo, numHeart: p.numHeart, numBreakHeart: p.numBreakHeart, numComment: p.numComment, createdAt: p.createdAt, authorPhoto: p.authorPhoto, authorName: p.authorName, categoryName: p.categoryName, isHeart: r?.isHeart)
                    }
                    return p
                }
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
                    .flatMapEach(on: req.eventLoop) { (p)  in
                        let reactQuery = SQLQueryString("SELECT r.id, r.is_heart as \"isHeart\", r.user_id as \"userID\", r.post_id as \"postID\" FROM reaction as r WHERE r.user_id = '\(raw: user.id!.uuidString)' and r.post_id = '\(raw: p.id!)'")
                                        
                        return db.raw(reactQuery)
                            .first(decoding: Reaction.Get.self)
                            .map { (r) in
                                return Post.GetFull(id: p.id, categoryID: p.categoryID, authorID: p.authorID, quote: p.quote, content: p.content, photo: p.photo, numHeart: p.numHeart, numBreakHeart: p.numBreakHeart, numComment: p.numComment, createdAt: p.createdAt, authorPhoto: p.authorPhoto, authorName: p.authorName, categoryName: p.categoryName, isHeart: r?.isHeart)
                            }
                    }
            }
    }
}
