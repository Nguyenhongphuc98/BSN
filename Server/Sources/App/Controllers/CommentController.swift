//
//  CommentController.swift
//  
//
//  Created by Phucnh on 10/18/20.
//

import Vapor
import Fluent
import SQLKit

struct CommentController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let comments = routes.grouped("api", "v1", "comments")
        let authen = comments.grouped(Account.authenticator())
        authen.get(use: index)
        authen.post(use: create)
        authen.group(":commentID") { group in
            group.delete(use: delete)
        }
        
        authen.get("newest", use: getNewest)
        authen.get("subs", use: getSubcomments)
    }

    func index(req: Request) throws -> EventLoopFuture<[Comment]> {
        return Comment.query(on: req.db).all()
    }

    func create(req: Request) throws -> EventLoopFuture<Comment> {
        let cmt = try req.content.decode(Comment.self)
        
        // Authen
        let account = try req.auth.require(Account.self)
        
        // Determine current user
        return User.query(on: req.db)
            .filter(\.$accountID == account.id!)
            .filter(\.$id == cmt.userID)
            .first()
            .unwrap(or: Abort(.forbidden))
            .flatMap { (user)  in
                
                // updaet number of comment of parent post
                _ = Post.query(on: req.db)
                    .filter(\.$id == cmt.postID)
                    .first()
                    .unwrap(or: Abort(.badRequest))
                    .map { (p) in
                        p.numComment = p.numComment! + 1
                        _ = p.update(on: req.db)
                    }
                
                return cmt.save(on: req.db).map { cmt }
            }
    }

    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return Comment.find(req.parameters.get("commentID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
    
    func getNewest(req: Request) throws -> EventLoopFuture<[Comment.GetFull]> {
        guard let pid: String = req.query["pid"], let page: Int = req.query["page"] else {
            throw Abort(.badRequest)
        }
        
        var per = BusinessConfig.newestCommentLimit
        if let p: Int = req.query["per"] {
            per = p
        }
        
        let offset = page * per
        
        // get full info to display card
        // filter comment at level 0 (post_id same parent_id)
        let sqlQuery = SQLQueryString("SELECT c.id, c.user_id as \"userID\", c.post_id as \"postID\", c.parent_id as \"parentID\", c.content, c.created_at as \"createdAt\", u.displayname as \"userName\", u.avatar as \"userPhoto\" FROM comment as c, public.user as u WHERE c.user_id = u.id and c.post_id = c.parent_id and c.post_id = '\(raw: pid)' order by c.created_at desc limit \(raw: per.description) offset \(raw: offset.description)")
        
        let db = req.db as! SQLDatabase
        return db.raw(sqlQuery)
            .all(decoding: Comment.GetFull.self)
    }
    
    func getSubcomments(req: Request) throws -> EventLoopFuture<[Comment.GetFull]> {
        guard let cmtid: String = req.query["cmtid"] else {
            throw Abort(.badRequest)
        }
        
        // get full info to display card
        // filter comment at level 0 (post_id same parent_id)
        let sqlQuery = SQLQueryString("SELECT c.id, c.user_id as \"userID\", c.post_id as \"postID\", c.parent_id as \"parentID\", c.content, c.created_at as \"createdAt\", u.displayname as \"userName\", u.avatar as \"userPhoto\" FROM comment as c, public.user as u WHERE c.user_id = u.id and c.parent_id = '\(raw: cmtid)'")
        
        let db = req.db as! SQLDatabase
        return db.raw(sqlQuery)
            .all(decoding: Comment.GetFull.self)
    }
}
