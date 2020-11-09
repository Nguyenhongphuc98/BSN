//
//  BorrowBookController.swift
//  
//
//  Created by Phucnh on 10/19/20.
//

import Vapor

struct BorrowBookController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let borrowBooks = routes.grouped("api" ,"v1", "borrowBooks")
        borrowBooks.get(use: index)
        borrowBooks.post(use: create)
        borrowBooks.group(":ID") { group in
            group.delete(use: delete)
        }
    }

    func index(req: Request) throws -> EventLoopFuture<[BorrowBook]> {
        return BorrowBook.query(on: req.db).all()
    }

    func create(req: Request) throws -> EventLoopFuture<BorrowBook> {
        let bb = try req.content.decode(BorrowBook.self)
        return bb.save(on: req.db).map { bb }
    }

    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return BorrowBook.find(req.parameters.get("ID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
}
