//
//  MessageController.swift
//  
//
//  Created by Phucnh on 10/18/20.
//

import Vapor
import Fluent
import SQLKit

struct MessageController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let messages = routes.grouped("api", "v1", "messages")
        let authen = messages.grouped(Account.authenticator())
        
        //authen.get(use: index)
        authen.post(use: create)
        authen.group(":messageID") { group in
            group.delete(use: delete)
        }
        
        authen.get("newest", use: getNewest)
    }

    //func index(req: Request) throws -> EventLoopFuture<[Message]> {
    //    return Message.query(on: req.db).all()
    //}

    func create(req: Request) throws -> EventLoopFuture<Message> {
        let message = try req.content.decode(Message.GetFull.self)
        let saveMess = message.toMessage()
        
        if message.chatID != nil {
            // If detect chat which message be long to
            // Just save it
            return saveMess.save(on: req.db).map { saveMess }
        } else {
            
            // try to find chat hold this message
            // Chat need find will have two id sender and receiver same
            return Chat.query(on: req.db)
                .group(.or, { (or) in
                    or.group(.and) { (and) in
                        and
                            .filter(\.$firstUserID == UUID(uuidString: message.senderID)!)
                            .filter(\.$secondUserID == UUID(uuidString: message.receiverID!)!)
                    }
                    .group(.and) { (and) in
                        and
                            .filter(\.$firstUserID == UUID(uuidString: message.receiverID!)!)
                            .filter(\.$secondUserID == UUID(uuidString: message.senderID)!)
                    }
                })
                .first()
                .flatMap { (c)  in
                    if let chat = c {
                        saveMess.chatID = chat.id
                        return saveMess.save(on: req.db).map { saveMess }
                    } else {
                        
                        let chat = Chat(firstUid: message.senderID, secondUid: message.receiverID!)
                        return chat.save(on: req.db).flatMap { _ in
                            saveMess.chatID = chat.id
                            return saveMess.save(on: req.db).map { saveMess }
                        }
                    }
                }
        }
    }

    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return Message.find(req.parameters.get("messageID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
    
    func getNewest(req: Request) throws -> EventLoopFuture<[Message.GetFull]> {
        
        guard let page: Int = req.query["page"] else {
            throw Abort(.badRequest)
        }
        
        guard let chatId: String = req.query["chatid"] else {
            throw Abort(.badRequest)
        }
        
        var per = BusinessConfig.newestChatLimit
        if let p: Int = req.query["per"] {
            per = p
        }
        
        
        let offset = page * per
        
        // Authen
        let account = try req.auth.require(Account.self)
        
        // Determine current user
        // Then get all notify of its
        return User.query(on: req.db)
            .filter(\.$accountID == account.id!)
            .first()
            .unwrap(or: Abort(.notFound))
            .flatMap { (u)  in
                
                
                let sqlQuery = SQLQueryString("SELECT m.id, m.chat_id as \"chatID\", m.sender_id as \"senderID\", m.content, m.created_at as \"createAt\", mt.name as \"typeName\" from message as m, message_type as mt where m.type_id = mt.id and m.chat_id = '\(raw: chatId)' order by m.created_at desc limit \(raw: per.description) offset \(raw: offset.description)");
                
                let db = req.db as! SQLDatabase
                return db.raw(sqlQuery)
                    .all(decoding: Message.GetFull.self)
            }
    }
}
