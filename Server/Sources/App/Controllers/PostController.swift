//
//  PostController.swift
//  
//
//  Created by Phucnh on 10/18/20.
//

import Vapor

struct PostController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let posts = routes.grouped("api" ,"v1", "posts")
        posts.get(use: index)
        posts.post(use: create)
        posts.group(":postID") { user in
            user.delete(use: delete)
        }
    }

    func index(req: Request) throws -> EventLoopFuture<[Post]> {
        return Post.query(on: req.db).all()
    }

    func create(req: Request) throws -> EventLoopFuture<Post> {
        let post = try req.content.decode(Post.self)
        return post.save(on: req.db).map { post }
    }

    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return Post.find(req.parameters.get("postID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
}
