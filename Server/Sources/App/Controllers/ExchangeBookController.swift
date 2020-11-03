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
        exchangeBooks.get("detail", ":id", use: getDetail)
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
    func getNewest(req: Request) throws -> EventLoopFuture<[GetExchangeBook]> {
        
        guard let page: Int = req.query["page"] else {
            throw Abort(.badRequest)
        }
        
        var per = BusinessConfig.newestEBLimit
        if let p: Int = req.query["per"] {
            per = p
        }
        
        let offset = page * per
        
        let sqlQuery = SQLQueryString("SELECT ex.id, bu.title as \"firstTitle\", bu.author as \"firstAuthor\", bu.cover as \"firstCover\", u.location, b.title as \"secondTitle\", b.author as \"secondAuthor\" FROM exchange_book as ex, user_book as ub, public.user as u, book as bu, book as b where ex.first_user_book_id = ub.id and ub.user_id = u.id and ex.exchange_book_id = b.id and ub.book_id = bu.id order by ex.created_at desc limit \(raw: per.description) offset \(raw: offset.description)")
        
        let db = req.db as! SQLDatabase
        return db.raw(sqlQuery)
            .all(decoding: GetExchangeBook.self)
    }
    
    func getDetail(req: Request) throws -> EventLoopFuture<GetExchangeBook> {
        
        // Assum curent user is: "C4285ABE-F520-46F3-97A3-508D94177D9C"
        let curentUID = "C4285ABE-F520-46F3-97A3-508D94177D9C"
        
        return ExchangeBook.find(req.parameters.get("id"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { eb in
            
                let db = req.db as! SQLDatabase
                let ub1Query = SQLQueryString("SELECT b.title, b.cover, b.author, ub.status, ub.status_des, u.displayname as \"ownerName\" FROM user_book as ub, book as b, public.user as u WHERE ub.user_id = u.id and ub.book_id = b.id and ub.id = '\(raw: eb.firstUserBookID!.uuidString)'")
                
                let ub1 =  db.raw(ub1Query)
                    .first(decoding: SearchUserBook.self)
                
                var sqlStr = "SELECT b.title, b.cover, b.author, ub.status, ub.status_des, u.displayname as \"ownerName\" FROM user_book as ub, book as b, public.user as u WHERE ub.user_id = u.id and ub.book_id = b.id and ub.user_id = '\(curentUID)' and ub.book_id = b.id"
                
                // state != new
                if eb.secondUserBookID != nil {
                    // it mean get info to accept or decline
                    // rather than submit final step exchange for current transaction
                    sqlStr = "SELECT b.title, b.cover, b.author, ub.status, ub.status_des, u.displayname as \"ownerName\" FROM user_book as ub, book as b, public.user as u WHERE ub.user_id = u.id and ub.book_id = b.id and ub.id = '\(eb.secondUserBookID!.uuidString)'"
                }
                
                
                let ub2Query = SQLQueryString(sqlStr)
                
                let ub2 =  db.raw(ub2Query)
                    .first(decoding: SearchUserBook.self)
                
                return ub1.and(ub2).map { (u1, u2) -> (GetExchangeBook) in
                    GetExchangeBook(
                        id: eb.id!.uuidString,
                        firstTitle: u1!.title,
                        firstAuthor: u1!.author,
                        firstCover: u1!.cover!,
                        secondTitle: u2 != nil ? u2!.title : nil,
                        secondAuthor: u2 != nil ? u2!.author : nil,
                        firstOwnerName: u1!.ownerName,
                        secondStatus: u2 != nil ? u2!.status : nil,
                        state: eb.state
                    )
                }
            }
    }
}

//SELECT b.title, b.cover, b.author, ub.status, ub.status_des, u.displayname as "ownerName" FROM user_book as ub, book as b, public.user as u WHERE ub.user_id = u.id and ub.book_id = b.id and ub.id = '246D461F-B648-48CA-B9AC-6219C82DFA2A'
