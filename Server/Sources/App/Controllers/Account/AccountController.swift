//
//  AccountController.swift
//  
//
//  Created by Phucnh on 10/15/20.
//

import Vapor
import Fluent

struct AccountController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let accounts = routes.grouped("api", "v1", "accounts")
        let authen = accounts.grouped(Account.authenticator())
        
        authen.get(use: index)
        authen.group(":accountID") { gr in
            gr.delete(use: delete)
        }
        
        authen.get("login", use: login)
        authen.delete("logout", use: logout)
        authen.post("register", use: create)
        authen.put(use: update)
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
                    cover: "https://farm4.staticflickr.com/3692/10621312106_02476d5c63_o.jpg", // default cover
                    location: "0-0- ", // default location
                    accountID: account.id!)
                
                return user.save(on: req.db)
                    .map { return account }
            }
    }
    
    // update onboard
    // or change password
    func update(req: Request) throws -> EventLoopFuture<Account> {
        
        let updateAccount = try req.content.decode(Account.Update.self)
        
        // Authen
        let account = try req.auth.require(Account.self)
               
        return Account.find(account.id!, on: req.db)
            .unwrap(or: Abort(.forbidden))
            .flatMap { (account)  in
                // we only can update 2 filed
                if updateAccount.isOnboarded != nil {
                    account.isOnboarded = updateAccount.isOnboarded!
                }
                if updateAccount.password != nil {
                    account.password = try! Bcrypt.hash(updateAccount.password!)
                }
                return account.update(on: req.db).map {
                    account
                }
            }
    }

    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return Account.find(req.parameters.get("accountID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
    
    func login(req: Request) throws -> Account {
        let ac = try req.auth.require(Account.self)
        return ac.asPublic()
    }
    
    func logout(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        // Authen
        let account = try req.auth.require(Account.self)
        
        // Determine current user
        return User.query(on: req.db)
            .filter(\.$accountID == account.id!)
            .first()
            .unwrap(or: Abort(.forbidden))
            .flatMap { (user)  in
                
                return Device.query(on: req.db)
                    .filter(\.$userID == user.id!)
                    .first()
                    .unwrap(or: Abort(.notFound))
                    .flatMap { $0.delete(on: req.db) }
                    .transform(to: .ok)
            }
    }
}
