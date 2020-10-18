//
//  UserController.swift
//  
//
//  Created by Phucnh on 10/16/20.
//

import Fluent
import Vapor

struct UserController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let users = routes.grouped("users")
        users.get(use: index)
        users.post(use: create)
        users.group(":userID") { user in
            user.delete(use: delete)
        }
    }

    func index(req: Request) throws -> EventLoopFuture<[User]> {
        return User.query(on: req.db).all()
    }

    func create(req: Request) throws -> EventLoopFuture<User> {
        let user = try req.content.decode(User.self)
        return user.save(on: req.db).map { user }
    }

    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return Account.find(req.parameters.get("userID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
}
