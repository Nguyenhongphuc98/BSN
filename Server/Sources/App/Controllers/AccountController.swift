//
//  AccountController.swift
//  
//
//  Created by Phucnh on 10/15/20.
//

import Fluent
import Vapor

struct AccountController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let accounts = routes.grouped("accounts")
        accounts.get(use: index)
        accounts.post(use: create)
        accounts.group(":accountID") { todo in
            todo.delete(use: delete)
        }
    }

    func index(req: Request) throws -> EventLoopFuture<[Account]> {
        return Account.query(on: req.db).all()
    }

    func create(req: Request) throws -> EventLoopFuture<Account> {
        let account = try req.content.decode(Account.self)
        return account.save(on: req.db).map { account }
    }

    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return Account.find(req.parameters.get("accountID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
}
