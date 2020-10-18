//
//  CommentController.swift
//  
//
//  Created by Phucnh on 10/18/20.
//

import Vapor

struct CommentController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let comments = routes.grouped("api", "v1", "comments")
        comments.get(use: index)
        comments.post(use: create)
        comments.group(":commentID") { user in
            user.delete(use: delete)
        }
    }

    func index(req: Request) throws -> EventLoopFuture<[Comment]> {
        return Comment.query(on: req.db).all()
    }

    func create(req: Request) throws -> EventLoopFuture<Comment> {
        let cmt = try req.content.decode(Comment.self)
        return cmt.save(on: req.db).map { cmt }
    }

    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return Comment.find(req.parameters.get("commentID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
}
