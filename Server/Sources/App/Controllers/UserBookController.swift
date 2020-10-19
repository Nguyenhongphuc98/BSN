//
//  UserBookController.swift
//  
//
//  Created by Phucnh on 10/19/20.
//

import Vapor

struct UserBookController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let userBooks = routes.grouped("api", "v1", "userBooks")
        userBooks.get(use: index)
        userBooks.post(use: create)
        userBooks.group(":ID") { user in
            user.delete(use: delete)
        }
    }

    func index(req: Request) throws -> EventLoopFuture<[UserBook]> {
        return UserBook.query(on: req.db).all()
    }

    func create(req: Request) throws -> EventLoopFuture<UserBook> {
        let ub = try req.content.decode(UserBook.self)
        return ub.save(on: req.db).map { ub }
    }

    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return UserBook.find(req.parameters.get("ID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
}
