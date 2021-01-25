//
//  UserBookController.swift
//  
//
//  Created by Phucnh on 10/19/20.
//

import Vapor
import SQLKit

enum BookState: String, CaseIterable, Equatable {
    case borrowed
    case available //to be borrowed
    case reading
    case exchanged
    case waitExchange
    case unknown
}

struct UserBookController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let userBooks = routes.grouped("api", "v1", "userBooks")
        userBooks.get(use: index)
        userBooks.post(use: create)
        userBooks.group(":ID") { group in
            group.delete(use: delete)
            group.put(use: update)
        }
        
        // Advance
        // Get all UserBook of a User
        userBooks.get("search", use: search)
        
        userBooks.get("available", use: searchAvailable)
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
    func search(req: Request) throws -> EventLoopFuture<[GetUserBook]> {
        
        var key = ""
        var value = ""
        
        if let uid: String = req.query["uid"] {
            key = "ub.user_id"
            value = uid
        }
        
        if let ubid: String = req.query["ubid"] {
            key = "ub.id"
            value = ubid
        }
        
        guard value != "" else {
            throw Abort(.badRequest)
        }
        
        let sqlQuery = SQLQueryString("SELECT b.title, b.cover, b.author, ub.status, ub.id, ub.user_id as \"userID\", ub.state, ub.book_id as \"bookID\", b.description, ub.status_des as \"statusDes\", u.displayname as \"ownerName\" FROM user_book as ub, book as b, public.user as u where ub.book_id = b.id and ub.user_id = u.id and \(raw: key) = '\(raw: value)'")
        
        let db = req.db as! SQLDatabase
        return db.raw(sqlQuery)
            .all(decoding: GetUserBook.self)
    }
    
    // Get all available book in shell of `book id`
    func searchAvailable(req: Request) throws -> EventLoopFuture<[GetUserBook]> {
        
        guard let bid:String = req.query["bid"] else {
            throw Abort(.badRequest)
        }
        
        let sqlQuery = SQLQueryString("SELECT ub.status, ub.id, ub.user_id as \"userID\", ub.book_id as \"bookID\", u.avatar as \"ownerAvatar\", u.location, u.displayname as \"ownerName\" FROM user_book as ub, book as b, public.user as u where ub.state = 'available' and ub.book_id = b.id and ub.user_id = u.id and ub.book_id = '\(raw: bid)'")
        
//        SELECT ub.status, ub.id, ub.user_id as "userID", u.avatar as "ownerAvatar", u.location, u.displayname as "ownerName" FROM user_book as ub, book as b, public.user as u where ub.state = 'available' and ub.book_id = b.id and ub.user_id = u.id and ub.book_id = 'E5136577-74FB-4FEF-B208-883CEE00587E'

        
        let db = req.db as! SQLDatabase
        return db.raw(sqlQuery)
            .all(decoding: GetUserBook.self)
    }
}
