//
//  CommentController.swift
//  
//
//  Created by Phucnh on 10/18/20.
//

import Vapor
import Fluent

struct CommentController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let comments = routes.grouped("api", "v1", "comments")
        comments.get(use: index)
        comments.post(use: create)
        comments.group(":commentID") { group in
            group.delete(use: delete)
        }
        
        //comments.get("search", use: search)
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
                        p.numComment = p.numComment + 1
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
    
//    func search(req: Request) throws -> EventLoopFuture<[Comment]> {
//        return Comment.query(on: req.db).all()
//    }
}
