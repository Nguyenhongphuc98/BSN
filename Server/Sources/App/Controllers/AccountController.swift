//
//  AccountController.swift
//  
//
//  Created by Phucnh on 10/15/20.
//

import Vapor

struct AccountController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let accounts = routes.grouped("api", "v1", "accounts")
        let authen = accounts.grouped(Account.authenticator())
        
        authen.get(use: index)
        authen.post(use: create)
        authen.group(":accountID") { user in
            user.delete(use: delete)
        }
        
        authen.get("login", use: login)
    }

    func index(req: Request) throws -> EventLoopFuture<[Account]> {
        return Account.query(on: req.db).all()
    }

    func create(req: Request) throws -> EventLoopFuture<Account> {
        try Account.Create.validate(content: req)
        let create = try req.content.decode(Account.Create.self)
        
        guard create.password == create.confirmPassword else {
            throw Abort(.badRequest, reason: "Passwords did not match")
        }
        
        let account = try Account(
            username: create.username,
            password: Bcrypt.hash(create.password)
        )
        return account.save(on: req.db)
            .flatMap {
                let user = User(
                    username: create.username,
                    displayname: create.name,
                    accountID: account.id!)
                
                return user.save(on: req.db)
                    .map { return account }
            }
    }

    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return Account.find(req.parameters.get("accountID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
    
    // Advance func
    func login(req: Request) throws -> Account {
        try req.auth.require(Account.self).asPublic()
    }
}
