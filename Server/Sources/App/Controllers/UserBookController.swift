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
        }
        
        // Advance
        // Get all UserBook of a User
        userBooks.get("users",":userID", use: search)
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
    
    // Advance function
    func search(req: Request) throws -> EventLoopFuture<[SearchUserBook]> {
        let uid = req.parameters.get("userID")! as String
        
        let sqlQuery = SQLQueryString("SELECT b.title, b.cover, b.author, ub.status FROM user_book as ub, book as b where ub.user_id = '\(raw: uid)' and ub.book_id = b.id")
        
        let db = req.db as! SQLDatabase
        return db.raw(sqlQuery)
            .all(decoding: SearchUserBook.self)
    }
}
