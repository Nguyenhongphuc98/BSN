//
//  ExchangeBookController.swift
//  
//
//  Created by Phucnh on 10/19/20.
//

import Vapor

struct ExchangeBookController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let exchangeBooks = routes.grouped("api" ,"v1", "exchangeBooks")
        exchangeBooks.get(use: index)
        exchangeBooks.post(use: create)
        exchangeBooks.group(":ID") { user in
            user.delete(use: delete)
        }
    }

    func index(req: Request) throws -> EventLoopFuture<[ExchangeBook]> {
        return ExchangeBook.query(on: req.db).all()
    }

    func create(req: Request) throws -> EventLoopFuture<ExchangeBook> {
        let eb = try req.content.decode(ExchangeBook.self)
        return eb.save(on: req.db).map { eb }
    }

    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return ExchangeBook.find(req.parameters.get("ID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
}
