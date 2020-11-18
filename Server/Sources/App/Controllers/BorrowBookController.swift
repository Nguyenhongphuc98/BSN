//
//  BorrowBookController.swift
//  
//
//  Created by Phucnh on 10/19/20.
//

import Vapor
import SQLKit
import Fluent

enum ExchangeProgess: String {
    // Just create ex
    case new
    // Someone sent reuqest ex, br
    case waiting
    // Owner don't want to exchange, br
    case decline
    // Owner accept
    case accept
    // Someone cancel request ex
    case cancel
}

struct BorrowBookController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let borrowBooks = routes.grouped("api" ,"v1", "borrowBooks")
        let authen = borrowBooks.grouped(Account.authenticator())
        
        authen.get(use: index)
        authen.post(use: create)
        authen.group(":ID") { group in
            group.delete(use: delete)
            group.put(use: update)
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
                    typeID: UUID(uuidString: NotifyType().borrow)!, // id of borrow action
                    actor: bb.borrowerID, // who submit
                    receiver: ub.userID, // who owner this book (userbook)
                    des: bb.id!
                )
                
                _ = notify.save(on: req.db)
            }
        
        return bb.save(on: req.db).map { bb }
    }
    
    func update(req: Request) throws -> EventLoopFuture<BorrowBook> {
       
        // There are 2 case need to consider
        // 1. The owner user-book decline borrow req
        // 2. Accept
        BorrowBook
            .find(req.parameters.get("ID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { bb in
                
                let newbb = try! req.content.decode(BorrowBook.GetFull.self)
                var notifyTypeID = NotifyType().borrowSuccess
                
                bb.state = newbb.state!
                if newbb.state == ExchangeProgess.decline.rawValue {
                    bb.message = newbb.message! // reason decline
                    notifyTypeID = NotifyType().borrowFail
                }
                
                // Find owner of this userbook
                _ = UserBook.query(on: req.db)
                    .filter(\.$id == bb.userBookID)
                    .first()
                    .unwrap(or: Abort(.notFound))
                    .map { (ub) in
                        
                        // Create notify to borrower
                        let notify = Notify(
                            typeID: UUID(uuidString: notifyTypeID)!,
                            actor: ub.userID, // who update
                            receiver: bb.borrowerID,
                            des: bb.id!
                        )
                        _ = notify.save(on: req.db)
                        
                        if newbb.state == ExchangeProgess.accept.rawValue {
                            // Update status of that borowbook to borowed
                            ub.state = BookState.borrowed.rawValue
                            _ = ub.update(on: req.db)
                            
                            // Create default message (chat) for them
                            let message = Message.GetFull(
                                senderID: ub.userID.uuidString,
                                content: "Chấp nhận yêu cầu mượn sách: '\(bb.message)'",
                                receiverID: bb.borrowerID.uuidString,
                                typeName: "text"
                            )
                            _ = try! MessageController().save(req: req, message: message)
                            
                            // Create userbook for borrower.
                            let userBook = UserBook(
                                uid: bb.borrowerID,
                                bid: ub.bookID,
                                status: ub.status,
                                state: BookState.reading.rawValue,
                                statusDes: ub.statusDes
                            )
                            _ = userBook.save(on: req.db)
                        }
                    }
                
                return bb.update(on: req.db).map { bb }
            }
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
        
        let sqlQuery = SQLQueryString("SELECT bb.id, bb.userbook_id as \"userBookID\", bb.borrower_id as \"borrowerID\", bb.borrow_date as \"borrowDate\", bb.borrow_days as \"borrowDays\", bb.adress, bb.message, bb.status_des as \"statusDes\", bb.state, b.cover  as \"bookCover\", b.title  as \"bookTitle\",b.author  as \"bookAuthor\", ub.status  as \"bookStatus\", u.displayname  as \"brorrowerName\" from borrow_book as bb, user_book as ub, public.user as u, book as b where bb.userbook_id = ub.id and ub.user_id = u.id and ub.book_id = b.id and bb.id = '\(raw: id)'")
        
        let db = req.db as! SQLDatabase
        return db.raw(sqlQuery)
            .first(decoding: BorrowBook.GetFull.self)
            .unwrap(or: Abort(.notFound))
    }
}
