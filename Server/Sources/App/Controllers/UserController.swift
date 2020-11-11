//
//  UserController.swift
//  
//
//  Created by Phucnh on 10/16/20.
//

import Vapor
import Fluent

struct UserController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let users = routes.grouped("api" ,"v1", "users")
        users.get(use: index)
        users.post(use: create)
        users.group(":userID") { group in
            group.delete(use: delete)
            group.get(use: get)
        }
        
        users.get("search", use: search)
    }

    func index(req: Request) throws -> EventLoopFuture<[User]> {
        return User.query(on: req.db).all()
    }

    func get(req: Request) throws -> EventLoopFuture<User> {
        return User.find(req.parameters.get("userID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .map { $0 }
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
    
    func search(req: Request) throws -> EventLoopFuture<User> {
        guard let term: String = req.query["aid"], let aid = UUID(uuidString: term)  else {
            throw Abort(.badRequest)
        }
        
        
        // Get first 5 book match term
        return User.query(on: req.db)
            .filter(\.$accountID == aid)
            .first()
            .unwrap(or: Abort(.notFound))
    }
}
