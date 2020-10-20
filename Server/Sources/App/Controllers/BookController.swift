//
//  BookController.swift
//  
//
//  Created by Phucnh on 10/19/20.
//

import Vapor
import Fluent

struct BookController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let books = routes.grouped("api" ,"v1", "books")
        
        books.get(use: index)
        books.post(use: create)
        books.group(":bookID") { book in
            book.delete(use: delete)
        }
        
        books.get("search", use: search)
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
    
    func search(req: Request) throws -> EventLoopFuture<[Book]> {
        guard let term: String = req.query["term"] else {
            throw Abort(.badRequest)
        }
        
        // Get first 5 book match term
        return Book.query(on: req.db)
            .group(.or) { (group) in
                group.filter(\.$title ~~ term).filter(\.$author ~~ term)
            }
            .range(0...4)
            .all()
    }
}
