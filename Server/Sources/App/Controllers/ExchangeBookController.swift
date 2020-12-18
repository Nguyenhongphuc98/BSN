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
        
        authen.group(":id") { group in
            group.delete(use: delete)
            group.get(use: get)
            group.put(use: update)
        }
        
        authen.get("newest", use: getNewest)
        authen.get("availables", ":id", use: getAvailableExs)
        authen.get("compute", ":id", use: getDetailInWatingState)
        authen.get("detail", ":id", use: getDetailAfterReqSubmited)
        authen.get("history", use: getHistory)
        authen.get("cancel", ":id", use: cancelRequest)
    }

    func index(req: Request) throws -> EventLoopFuture<[ExchangeBook]> {
        return ExchangeBook.query(on: req.db).all()
    }
    
    func get(req: Request) throws -> EventLoopFuture<ExchangeBook> {
        return ExchangeBook
            .find(req.parameters.get("id"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .map { $0 }
    }

    func create(req: Request) throws -> EventLoopFuture<ExchangeBook> {
        let eb = try req.content.decode(ExchangeBook.self)
        return eb.save(on: req.db).map { eb }
    }

    func update(req: Request) throws -> EventLoopFuture<ExchangeBook> {
        ExchangeBook
            .find(req.parameters.get("id"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { eb in
                // Decode
                let newEB = try! req.content.decode(ExchangeBook.self)
                var notifyTypeID = ""
                
                // Check it update from what state and to what state
                // Then process with each case
                
                // case 1: submit req
                // case 2: decline
                // case 3: accept
                
                // change .new to .waiting, it mean submit req exchange
                // case 1
                if newEB.state == ExchangeProgess.waiting.rawValue {
                    // Setup new value for update
                    if let secondUbid = newEB.secondUserBookID { eb.secondUserBookID = secondUbid }
                    if let address = newEB.adress { eb.adress = address }
                    if let message = newEB.message { eb.message = message }
                    if let statusDes = newEB.secondStatusDes { eb.secondStatusDes = statusDes }
                    notifyTypeID = NotifyType().exchange
                } else {
                    
                    // case 2: Decline req
                    if newEB.state == ExchangeProgess.decline.rawValue {
                        // Setup new value for update
                        if let message = newEB.message { eb.message = message }
                        notifyTypeID = NotifyType().exchangeFail
                    } else {
                        
                        // case 3: Accept
                        notifyTypeID = NotifyType().exchangeSuccess
                    }
                }
                
                // State allways update to make progess
                if let progess = newEB.state { eb.state = progess }
                
                // Setup to notify
                // Find owner of first user book
                let firstUser = UserBook.query(on: req.db)
                    .filter(\.$id == eb.firstUserBookID!)
                    //.field(\.$userID)
                    .first()
                    .unwrap(or: Abort(.notFound))
                  
                // Find owner of second user book
                let secondUser = UserBook.query(on: req.db)
                    .filter(\.$id == eb.secondUserBookID!)
                    //.field(\.$userID)
                    .first()
                    .unwrap(or: Abort(.notFound))
              
                return eb.update(on: req.db).map {
                    
                    _ = firstUser.and(secondUser).map { (ub1, ub2)  in
                        // insert notify
                        // if req -> notify to owner
                        // if accept/decline notify to exchanger
                        let notify = Notify(
                            typeID: UUID(uuidString: notifyTypeID)!,
                            actor: newEB.state == ExchangeProgess.waiting.rawValue ? ub2.userID : ub1.userID,
                            receiver: newEB.state == ExchangeProgess.waiting.rawValue ? ub1.userID : ub2.userID,
                            des: eb.id!
                        )
                        
                        //_ = notify.save(on: req.db)
                        NotifyController.create(req: req, notify: notify)
                        
                        // case 3: accept
                        if newEB.state == ExchangeProgess.accept.rawValue {
                            // If accept, we should update status userbook for 2 owner
                            ub1.state = BookState.exchanged.rawValue
                            _ = ub1.save(on: req.db)
                            
                            ub2.state = BookState.exchanged.rawValue
                            _ = ub2.save(on: req.db)
                            
                            // create new userbook
                            // U1 hold book same u2
                            let userBook1 = UserBook(
                                uid: ub1.userID,
                                bid: ub2.bookID,
                                status: ub2.status,
                                state: BookState.reading.rawValue,
                                statusDes: ub2.statusDes
                            )
                            _ = userBook1.save(on: req.db)
                            
                            // U2 hold book same u1
                            let userBook2 = UserBook(
                                uid: ub2.userID,
                                bid: ub1.bookID,
                                status: ub1.status,
                                state: BookState.reading.rawValue,
                                statusDes: ub1.statusDes
                            )
                            _ = userBook2.save(on: req.db)
                            
                            // Create default message (chat) for them
                            let message = Message.GetFull(
                                senderID: ub1.userID.uuidString,
                                content: "Chấp nhận yêu cầu đổi sách: '\(eb.message ?? "")'",
                                receiverID: ub2.userID.uuidString,
                                typeName: "text"
                            )
                            _ = try! MessageController().save(req: req, message: message)
                        }
                    }
                    
                    return eb
                }
            }
    }
    
    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return ExchangeBook.find(req.parameters.get("id"), on: req.db)
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
    
    // Get all available transaction created for special book id (in ub1)
    func getAvailableExs(req: Request) throws -> EventLoopFuture<[GetExchangeBook]> {
        
        guard let bid: String = req.parameters.get("id") else {
            throw Abort(.badRequest)
        }
        
        // b1 - book in userbook need change ub
        // b2 - book want to change
        // u - user owner userbook1
        let sqlQuery = SQLQueryString("SELECT ex.id, u.id as \"firstUserID\", u.displayname as \"firstOwnerName\", u.location, u.avatar as \"firstAvatar\", b2.title as \"secondTitle\", b2.id as \"secondBookID\", ub.status as \"firstStatus\", ex.exchange_book_id as \"exchangeBookID\" FROM exchange_book as ex, public.user as u, book as b1, book as b2, user_book as ub WHERE ex.first_user_book_id = ub.id and ub.book_id = b1.id and ex.exchange_book_id = b2.id and ub.user_id = u.id and ex.state = '\(raw: ExchangeProgess.new.rawValue)' and b1.id = '\(raw: bid)'")
        
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
                        let sqlQuery = SQLQueryString("SELECT eb.id, eb.first_user_book_id as \"firstUserBookID\", eb.second_user_book_id as \"secondUserBookID\", eb.adress, eb.message, eb.first_status_des as \"firstStatusDes\", eb.second_status_des as \"secondStatusDes\", eb.state, u1.displayname as \"firstOwnerName\", b1.title as \"firstTitle\", b1.author as \"firstAuthor\", b1.cover as \"firstCover\", u2.displayname as \"secondOwnerName\", b2.title as \"secondTitle\", b2.author as \"secondAuthor\", b2.cover as \"secondCover\" FROM exchange_book as eb, user_book as ub1, public.user as u1, book as b1, user_book as ub2, public.user as u2, book as b2 WHERE eb.first_user_book_id = ub1.id and ub1.user_id = u1.id and ub1.book_id = b1.id and eb.second_user_book_id = ub2.id and ub2.user_id = u2.id and ub2.book_id = b2.id and eb.id = '\(raw: eb.id!.uuidString)'")
                        
                        return db.raw(sqlQuery)
                            .first(decoding: GetExchangeBook.self)
                            .unwrap(or: Abort(.notFound))
                            .map { $0 }
                    }
            }
    }
    
    func getHistory(req: Request) throws -> EventLoopFuture<[GetExchangeBook]> {
        // Get history for current user
              
        // Authen
        let account = try req.auth.require(Account.self)
        
        // Determine current user
        return User.query(on: req.db)
            .filter(\.$accountID == account.id!)
            .first()
            .unwrap(or: Abort(.forbidden))
            .flatMap { (u)  in
                
                // Get needed info from eb and userbook 1 -> L
                // Get needed info from userbook 2 -> R
                // Left join L and R (incase ex sate = new, right clause will empty
                // Filter just get of current user (owner or exchanger)
                
                let sqlQuery = SQLQueryString("SELECT T.*, T.firstuserid as \"firstUserID\", T.seconduserid as \"secondUserID\" FROM (SELECT * FROM (SELECT eb.id, eb.second_user_book_id as \"ub2id\", eb.state, eb.updated_at as \"updatedAt\", u1.id as \"firstuserid\", u1.displayname as \"firstOwnerName\", b1.title as \"firstTitle\" FROM user_book as ub1, public.user as u1, book as b1, exchange_book as eb WHERE eb.first_user_book_id = ub1.id and ub1.user_id = u1.id and ub1.book_id = b1.id order by eb.updated_at desc) L LEFT JOIN (SELECT ub2.id as \"ub2id\", u2.id as \"seconduserid\", u2.displayname as \"secondOwnerName\", b2.title as \"secondTitle\" FROM public.user as u2, book as b2, user_book as ub2 WHERE ub2.user_id = u2.id and ub2.book_id = b2.id) R ON L.ub2id = R.ub2id) T WHERE T.firstuserid = '\(raw: u.id!.uuidString)' or T.seconduserid = '\(raw: u.id!.uuidString)'")
                
                                
                let db = req.db as! SQLDatabase
                return db.raw(sqlQuery)
                    .all(decoding: GetExchangeBook.self)
            }
    }
    
    // Cancel exchange by owner or partner req cancel
    // Owner just can cancel when it in new state
    func cancelRequest(req: Request) throws -> EventLoopFuture<ExchangeBook> {
       
        guard let ebIdStr: String = req.parameters.get("id"), let ebid = UUID(uuidString: ebIdStr) else {
            throw Abort(.badRequest)
        }
        
        // Authen
        let account = try req.auth.require(Account.self)
        
        // Determine current user
        return User.query(on: req.db)
            .filter(\.$accountID == account.id!)
            .first()
            .unwrap(or: Abort(.notFound))
            .flatMap { (user)  in
                
                // Cancel req dont' need notify to anyone
                return ExchangeBook
                    .query(on: req.db)
                    .filter(\.$id == ebid)
                    .first()
                    .unwrap(or: Abort(.badRequest))
                    .flatMap { (eb) -> EventLoopFuture<ExchangeBook> in
                        
                        if eb.state == ExchangeProgess.new.rawValue {
                            // Find owner to verify and update state
                            return UserBook.query(on: req.db)
                                .filter(\.$id == eb.firstUserBookID!)
                                .filter(\.$userID == user.id!)
                                .first()
                                .unwrap(or: Abort(.forbidden))
                                .flatMap { (ub) -> EventLoopFuture<ExchangeBook> in
                                    
                                    eb.state = ExchangeProgess.cancel.rawValue
                                    return eb.update(on: req.db).map { eb }
                                }
                        } else {
                            // Find requester to verify and cancel req
                            return UserBook.query(on: req.db)
                                .filter(\.$id == eb.secondUserBookID ?? UUID()) //avoid someone make invalid req crash app
                                .filter(\.$userID == user.id!)
                                .first()
                                .unwrap(or: Abort(.forbidden))
                                .flatMap { (ub) -> EventLoopFuture<ExchangeBook> in
                                    
                                    // Create new exchange for owner
                                    let newEb = ExchangeBook()
                                    newEb.firstUserBookID = eb.firstUserBookID
                                    newEb.exchangeBookID = eb.exchangeBookID
                                    newEb.firstStatusDes = eb.firstStatusDes
                                    newEb.state = ExchangeProgess.new.rawValue
                                    
                                    _ = newEb.save(on: req.db)
                                    
                                    eb.state = ExchangeProgess.cancel.rawValue
                                    return eb.update(on: req.db).map { eb }
                                }
                        }
                    }
                
            }
    }
}

//SELECT T.*, T.firstuserid as "firstUserID", T.seconduserid as "secondUserID" FROM (SELECT * FROM (SELECT eb.id, eb.second_user_book_id as "ub2id", eb.state, eb.updated_at as "updatedAt", u1.id as "firstuserid", u1.displayname as "firstOwnerName", b1.title as "firstTitle" FROM user_book as ub1, public.user as u1, book as b1, exchange_book as eb WHERE eb.first_user_book_id = ub1.id and ub1.user_id = u1.id and ub1.book_id = b1.id order by eb.updated_at desc) L LEFT JOIN (SELECT ub2.id as "ub2id", u2.id as "seconduserid", u2.displayname as "secondOwnerName", b2.title as "secondTitle" FROM public.user as u2, book as b2, user_book as ub2 WHERE ub2.user_id = u2.id and ub2.book_id = b2.id) R ON L.ub2id = R.ub2id) T WHERE T.firstuserid = '24462eef-f473-4e0c-942a-352d3162eb9a' or T.seconduserid = '24462eef-f473-4e0c-942a-352d3162eb9a'
