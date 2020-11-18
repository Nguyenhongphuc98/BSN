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
        let authen = exchangeBooks.grouped(Account.authenticator())
        authen.get(use: index)
        authen.post(use: create)
        
        authen.group(":ID") { group in
            group.delete(use: delete)
            group.get(use: get)
            group.put(use: update)
        }
        
        authen.get("newest", use: getNewest)
        authen.get("compute", ":id", use: getDetailInWatingState)
        authen.get("detail", ":id", use: getDetailAfterReqSubmited)
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

    func update(req: Request) throws -> EventLoopFuture<ExchangeBook> {
        ExchangeBook
            .find(req.parameters.get("ID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { eb in
                // Decode
                let newEB = try! req.content.decode(ExchangeBook.self)
                
                // Setup new value for update
                if let secondUbid = newEB.secondUserBookID { eb.secondUserBookID = secondUbid }
                if let address = newEB.adress { eb.adress = address }
                if let message = newEB.message { eb.message = message }
                if let progess = newEB.state { eb.state = progess }
                if let statusDes = newEB.secondStatusDes { eb.secondStatusDes = statusDes }
                
                // Setup to notify
                // Find owner of first user book
                let firstUser = UserBook.query(on: req.db)
                    .filter(\.$id == eb.firstUserBookID!)
                    .field(\.$userID)
                    .first()
                    .unwrap(or: Abort(.notFound))
                  
                // Find owner of second user book
                let secondUser = UserBook.query(on: req.db)
                    .filter(\.$id == eb.secondUserBookID!)
                    .field(\.$userID)
                    .first()
                    .unwrap(or: Abort(.notFound))
                
                _ = firstUser.and(secondUser).map { (ub1, ub2)  in
                    // insert notify for owner
                    let notify = Notify(
                        typeID: UUID(uuidString: "B5C0EA0E-EAF6-47DC-A15B-12869159F875")!, // id of exchange action
                        actor: ub2.userID, // who submit
                        receiver: ub1.userID, // who owner this book (userbook)
                        des: eb.id!
                    )
                    
                    _ = notify.save(on: req.db)
                }
                
                return eb.update(on: req.db).map { eb }
            }
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
        
        let sqlQuery = SQLQueryString("SELECT ex.id, bu.title as \"firstTitle\", bu.author as \"firstAuthor\", bu.cover as \"firstCover\", u.location, b.title as \"secondTitle\", b.author as \"secondAuthor\" FROM exchange_book as ex, user_book as ub, public.user as u, book as bu, book as b where ex.first_user_book_id = ub.id and ub.user_id = u.id and ex.exchange_book_id = b.id and ub.book_id = bu.id and ex.state = 'new' order by ex.created_at desc limit \(raw: per.description) offset \(raw: offset.description)")
        
        let db = req.db as! SQLDatabase
        return db.raw(sqlQuery)
            .all(decoding: GetExchangeBook.self)
    }
    
    // This func shoud just get to make request to owner (who create exchange in wating state)
    // Get info after send req will be implement in other func
    func getDetailInWatingState(req: Request) throws -> EventLoopFuture<GetExchangeBook> {
        
        // Authen
        let account = try req.auth.require(Account.self)
        
        // Determine current user
        // Then get appropriate info
        return User.query(on: req.db)
            .filter(\.$accountID == account.id!)
            .first()
            .unwrap(or: Abort(.notFound))
            .flatMap { (u)  in
                
                return ExchangeBook.find(req.parameters.get("id"), on: req.db)
                    .unwrap(or: Abort(.notFound))
                    .flatMap { eb in
                    
                        let db = req.db as! SQLDatabase
                        let ub1Query = SQLQueryString("SELECT b.title, b.cover, b.author, ub.id, ub.status, ub.status_des as \"statusDes\", u.displayname as \"ownerName\" FROM user_book as ub, book as b, public.user as u WHERE ub.user_id = u.id and ub.book_id = b.id and ub.id = '\(raw: eb.firstUserBookID!.uuidString)'")
                        
                        let ub1 = db.raw(ub1Query)
                            .first(decoding: GetUserBook.self)
                        
                        let sqlStr = "SELECT b.title, b.cover, b.author, ub.status, ub.id,ub.status_des as \"statusDes\", u.displayname as \"ownerName\" FROM user_book as ub, book as b, public.user as u WHERE ub.user_id = u.id and ub.book_id = b.id and b.id = '\(eb.exchangeBookID!.uuidString)' and ub.user_id = '\(u.id!.uuidString)'"
                        
                        // state != new
//                        if eb.secondUserBookID != nil {
//                            // it mean get info to accept or decline
//                            // rather than submit final step exchange for current transaction
//                            sqlStr = "SELECT b.title, b.cover, b.author, ub.id, ub.status, ub.status_des as \"statusDes\", u.displayname as \"ownerName\" FROM user_book as ub, book as b, public.user as u WHERE ub.user_id = u.id and ub.book_id = b.id and ub.id = '\(eb.secondUserBookID!.uuidString)'"
//                        }
                        
                        let ub2Query = SQLQueryString(sqlStr)
                        
                        let ub2 = db.raw(ub2Query)
                            .first(decoding: GetUserBook.self)
                        
                        let bookQuery = SQLQueryString("SELECT b.title, b.cover, b.author FROM book as b WHERE b.id = '\(raw: eb.exchangeBookID!.uuidString)'")
                        
                        let book = db.raw(bookQuery)
                            .first(decoding: GetUserBook.self)
                        
                        return book.flatMap { (b) -> EventLoopFuture<GetExchangeBook> in
                            return ub1.and(ub2).map { (u1, u2) -> (GetExchangeBook) in
                                if u2 == nil {
                                    
                                    return GetExchangeBook(
                                        id: eb.id!.uuidString,
                                        firstubid: u1?.id,
                                        firstTitle: u1!.title!,
                                        firstAuthor: u1!.author!,
                                        firstCover: u1!.cover!,
                                        secondTitle: b?.title,
                                        secondAuthor: b?.author,
                                        firstOwnerName: u1!.ownerName,
                                        firstStatus: u1!.status,
                                        firstStatusDes: eb.firstStatusDes, // it should get statusdes at the time creare ex rather than at current
                                        secondStatus: b?.status,
                                        secondStatusDes: b?.statusDes,
                                        secondCover: b?.cover,
                                        state: eb.state
                                    )
                                } else {
                                    
                                    return GetExchangeBook(
                                        id: eb.id!.uuidString,
                                        firstubid: u1?.id,
                                        secondubid: u2?.id,
                                        firstTitle: u1!.title!,
                                        firstAuthor: u1!.author!,
                                        firstCover: u1!.cover!,
                                        secondTitle: u2 != nil ? u2!.title : nil,
                                        secondAuthor: u2 != nil ? u2!.author : nil,
                                        firstOwnerName: u1!.ownerName,
                                        firstStatus: u1!.status,
                                        firstStatusDes: u1!.statusDes,
                                        secondStatus: u2?.status,
                                        secondStatusDes: u2?.statusDes,
                                        secondCover: u2?.cover,
                                        state: eb.state
                                    )
                                }
                            }
                        }
                    }
            }
    }
    
    func getDetailAfterReqSubmited(req: Request) throws -> EventLoopFuture<GetExchangeBook> {
        
        // Authen
        let account = try req.auth.require(Account.self)
        
        // Determine current user
        // Then get appropriate info
        return User.query(on: req.db)
            .filter(\.$accountID == account.id!)
            .first()
            .unwrap(or: Abort(.notFound))
            .flatMap { (u)  in
                
                return ExchangeBook.find(req.parameters.get("id"), on: req.db)
                    .unwrap(or: Abort(.notFound))
                    .flatMap { eb in
                    
                        let db = req.db as! SQLDatabase
                        let sqlQuery = SQLQueryString("SELECT eb.id, eb.first_user_book_id as \"firstubid\", eb.second_user_book_id as \"secondubid\", eb.adress, eb.message, eb.first_status_des as \"firstStatusDes\", eb.second_status_des as \"secondStatusDes\", eb.state, u1.displayname as \"firstOwnerName\", b1.title as \"firstTitle\", b1.author as \"firstAuthor\", b1.cover as \"firstCover\", u2.displayname as \"secondOwnerName\", b2.title as \"secondTitle\", b2.author as \"secondAuthor\", b2.cover as \"secondCover\" FROM exchange_book as eb, user_book as ub1, public.user as u1, book as b1, user_book as ub2, public.user as u2, book as b2 WHERE eb.first_user_book_id = ub1.id and ub1.user_id = u1.id and ub1.book_id = b1.id and eb.second_user_book_id = ub2.id and ub2.user_id = u2.id and ub2.book_id = b2.id and eb.id = '\(raw: eb.id!.uuidString)'")
                        
                        return db.raw(sqlQuery)
                            .first(decoding: GetExchangeBook.self)
                            .unwrap(or: Abort(.notFound))
                            .map { $0 }
                    }
            }
    }
}
