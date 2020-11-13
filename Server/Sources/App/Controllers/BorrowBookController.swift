//
//  BorrowBookController.swift
//  
//
//  Created by Phucnh on 10/19/20.
//

import Vapor
import SQLKit
import Fluent

struct BorrowBookController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let borrowBooks = routes.grouped("api" ,"v1", "borrowBooks")
        let authen = borrowBooks.grouped(Account.authenticator())
        
        authen.get(use: index)
        authen.post(use: create)
        authen.group(":ID") { group in
            group.delete(use: delete)
        }
        
        authen.get("detail", ":ID", use: getDetail)
    }

    func index(req: Request) throws -> EventLoopFuture<[BorrowBook]> {
        return BorrowBook.query(on: req.db).all()
    }

    func create(req: Request) throws -> EventLoopFuture<BorrowBook> {
        let bb = try req.content.decode(BorrowBook.self)
        
        // Find owner of this userbook
        _ = UserBook.query(on: req.db)
            .filter(\.$id == bb.userBookID)
            .field(\.$userID)
            .first()
            .unwrap(or: Abort(.notFound))
            .map { (ub) in
                
                // insert notify for owner
                let notify = Notify(
                    typeID: UUID(uuidString: "208F948B-E3F4-4F33-98A0-0D17976180DD")!, // id of borrow action
                    actor: bb.borrowerID, // who submit
                    receiver: ub.userID, // who owner this book (userbook)
                    des: bb.id!
                )
                
                _ = notify.save(on: req.db)
            }
        
        return bb.save(on: req.db).map { bb }
    }

    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return BorrowBook.find(req.parameters.get("ID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
    
    func getDetail(req: Request) throws -> EventLoopFuture<BorrowBook.GetFull> {
        
        guard let id: String = req.parameters.get("ID"), let _ = UUID(uuidString: id) else {
            throw Abort(.badRequest)
        }
        
        // Authen
        _ = try req.auth.require(Account.self)
        
        let sqlQuery = SQLQueryString("SELECT bb.userbook_id as \"userBookID\", bb.borrower_id as \"borrowerID\", bb.borrow_date as \"borrowDate\", bb.borrow_days as \"borrowDays\", bb.adress, bb.message, bb.status_des as \"statusDes\", bb.state, b.cover  as \"bookCover\", b.title  as \"bookTitle\",b.author  as \"bookAuthor\", ub.status  as \"bookStatus\", u.displayname  as \"brorrowerName\" from borrow_book as bb, user_book as ub, public.user as u, book as b where bb.userbook_id = ub.id and ub.user_id = u.id and ub.book_id = b.id and bb.id = '\(raw: id)'")
        
        let db = req.db as! SQLDatabase
        return db.raw(sqlQuery)
            .first(decoding: BorrowBook.GetFull.self)
            .unwrap(or: Abort(.notFound))
    }
}
