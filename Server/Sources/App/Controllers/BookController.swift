//
//  BookController.swift
//  
//
//  Created by Phucnh on 10/19/20.
//

import Vapor

struct BookController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let posts = routes.grouped("api" ,"v1", "books")
        posts.get(use: index)
        posts.post(use: create)
        posts.group(":bookID") { user in
            user.delete(use: delete)
        }
    }

    func index(req: Request) throws -> EventLoopFuture<[Book]> {
        return Book.query(on: req.db).all()
    }

    func create(req: Request) throws -> EventLoopFuture<Book> {
        let book = try req.content.decode(Book.self)
        return book.save(on: req.db).map { book }
    }

    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return Book.find(req.parameters.get("bookID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
}
