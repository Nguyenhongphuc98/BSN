//
//  BorrowBookController.swift
//  
//
//  Created by Phucnh on 10/19/20.
//

import Vapor
import Fluent

struct BorrowBookController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let borrowBooks = routes.grouped("api" ,"v1", "borrowBooks")
        borrowBooks.get(use: index)
        borrowBooks.post(use: create)
        borrowBooks.group(":ID") { group in
            group.delete(use: delete)
        }
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
}
