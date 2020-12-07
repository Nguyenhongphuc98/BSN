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
        let authen = users.grouped(Account.authenticator())
        authen.get(use: index)
        authen.post(use: create)
        authen.group(":ID") { group in
            group.delete(use: delete)
            group.get(use: get)
            group.put(use: update)
        }
        
        authen.get("search", use: search)
    }

    func index(req: Request) throws -> EventLoopFuture<[User]> {
        return User.query(on: req.db).all()
    }

    func get(req: Request) throws -> EventLoopFuture<User> {
        return User.find(req.parameters.get("ID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .map { $0 }
    }
    
    func create(req: Request) throws -> EventLoopFuture<User> {
        let user = try req.content.decode(User.self)
        return user.save(on: req.db).map { user }
    }

    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return Account.find(req.parameters.get("ID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
    
    func search(req: Request) throws -> EventLoopFuture<User> {
        guard let term: String = req.query["aid"], let aid = UUID(uuidString: term)  else {
            throw Abort(.badRequest)
        }
        
        
        // Get first user match aid
        return User.query(on: req.db)
            .filter(\.$accountID == aid)
            .first()
            .unwrap(or: Abort(.notFound))
    }
    
    func update(req: Request) throws -> EventLoopFuture<User> {
        let newUser = try! req.content.decode(User.Update.self)
        
        guard let uid: UUID = req.parameters.get("ID") else {
            throw Abort(.badRequest)
        }
        
        // Authen
        let account = try req.auth.require(Account.self)
        
        return User
            .query(on: req.db)
            .filter(\.$id == uid)
            .filter(\.$accountID == account.id!) // Curren user can update info of him
            .first()
            .unwrap(or: Abort(.forbidden))
            .flatMap { user in
                
                user.displayname = newUser.displayname != nil ? newUser.displayname! : user.displayname
                user.about = newUser.about != nil ? newUser.about! : user.about
                user.avatar = newUser.avatar != nil ? newUser.avatar! : user.avatar
                user.cover = newUser.cover != nil ? newUser.cover! : user.cover
                user.location = newUser.location != nil ? newUser.location! : user.location
                
                return user.update(on: req.db).map { user }
            }
    }
}
