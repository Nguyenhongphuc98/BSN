//
//  ExchangeBookController.swift
//  
//
//  Created by Phucnh on 10/19/20.
//

import Vapor
import SQLKit
import Fluent

struct ExchangeBookController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let exchangeBooks = routes.grouped("api" ,"v1", "exchangeBooks")
        exchangeBooks.get(use: index)
        exchangeBooks.post(use: create)
        
        exchangeBooks.group(":ID") { group in
            group.delete(use: delete)
            group.get(use: get)
        }
        
        exchangeBooks.get("newest", use: getNewest)
    }

    func index(req: Request) throws -> EventLoopFuture<[ExchangeBook]> {
        return ExchangeBook.query(on: req.db).all()
    }
    
    func get(req: Request) throws -> EventLoopFuture<ExchangeBook> {
        return ExchangeBook
            .find(req.parameters.get("ID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .map { $0 }
    }

    func create(req: Request) throws -> EventLoopFuture<ExchangeBook> {
        let eb = try req.content.decode(ExchangeBook.self)
        return eb.save(on: req.db).map { eb }
    }

    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return ExchangeBook.find(req.parameters.get("ID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
    
    // advance
    func getNewest(req: Request) throws -> EventLoopFuture<[NewestEB]> {
        
        guard let page: Int = req.query["page"] else {
            throw Abort(.badRequest)
        }
        
        var per = BusinessConfig.newestEBLimit
        if let p: Int = req.query["per"] {
            per = p
        }
        
        let offset = page * per
        
        let sqlQuery = SQLQueryString("SELECT bu.title as \"needChangeTitle\", bu.author as \"needChangeAuthor\", bu.cover as \"needChangeCover\", u.location, b.title as \"wantChangeTitle\", b.author as \"wantChangeAuthor\" FROM exchange_book as ex, user_book as ub, public.user as u, book as bu, book as b where ex.first_user_book_id = ub.id and ub.user_id = u.id and ex.exchange_book_id = b.id and ub.book_id = bu.id order by ex.created_at desc limit \(raw: per.description) offset \(raw: offset.description)")
        
        let db = req.db as! SQLDatabase
        return db.raw(sqlQuery)
            .all(decoding: NewestEB.self)
    }
}
