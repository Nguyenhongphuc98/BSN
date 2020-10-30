//
//  UserBookController.swift
//  
//
//  Created by Phucnh on 10/19/20.
//

import Vapor
//import SwifQL
import SQLKit

struct UserBookController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let userBooks = routes.grouped("api", "v1", "userBooks")
        userBooks.get(use: index)
        userBooks.post(use: create)
        userBooks.group(":ID") { user in
            user.delete(use: delete)
            user.put(use: update)
        }
        
        // Advance
        // Get all UserBook of a User
        userBooks.get("search", use: search)
    }

    func index(req: Request) throws -> EventLoopFuture<[UserBook]> {
        return UserBook.query(on: req.db).all()
    }

    func create(req: Request) throws -> EventLoopFuture<UserBook> {
        let ub = try req.content.decode(UserBook.self)
        return ub.save(on: req.db).map { ub }
    }
    
    func update(req: Request) throws -> EventLoopFuture<UserBook> {
        UserBook
            .find(req.parameters.get("ID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { currentUB in
                let newUB = try! req.content.decode(UpdateUserbook.self)
                currentUB.state = newUB.state != nil ? newUB.state! : currentUB.state
                currentUB.status = newUB.status != nil ? newUB.status! : currentUB.status
                currentUB.statusDes = newUB.statusDes != nil ? newUB.statusDes! : currentUB.statusDes

                return currentUB.update(on: req.db).map { currentUB }
            }
    }

    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return UserBook.find(req.parameters.get("ID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
    
    // Advance function
    // Get all book in shell of a user `[UserBook]`
    func search(req: Request) throws -> EventLoopFuture<[SearchUserBook]> {
        guard let uid: String = req.query["uid"] else {
            throw Abort(.badRequest)
        }
        
        let sqlQuery = SQLQueryString("SELECT b.title, b.cover, b.author, ub.status, ub.id, ub.user_id as \"userID\", ub.state, ub.book_id as \"bookID\" FROM user_book as ub, book as b where ub.user_id = '\(raw: uid)' and ub.book_id = b.id")
        
        let db = req.db as! SQLDatabase
        return db.raw(sqlQuery)
            .all(decoding: SearchUserBook.self)
    }
}
