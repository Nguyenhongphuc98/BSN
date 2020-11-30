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
        
        return try save(req: req, message: message)
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

extension MessageController {
    
    func save(req: Request, message: Message.GetFull) throws -> EventLoopFuture<Message> {
        let saveMess = message.toMessage()
        
        if message.chatID != nil {
            // If detect chat which message be long to
            // Just save it
            return saveMess.save(on: req.db).map {
                broadcastMessage(req: req, mess: saveMess, typeName: message.typeName!)
                return saveMess
            }
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
                        broadcastMessage(req: req, mess: saveMess, typeName: message.typeName!)
                        return saveMess.save(on: req.db).map { saveMess }
                    } else {
                        
                        let chat = Chat(firstUid: message.senderID, secondUid: message.receiverID!)
                        return chat.save(on: req.db).flatMap { _ in
                            saveMess.chatID = chat.id
                            broadcastMessage(req: req, mess: saveMess, typeName: message.typeName!)
                            return saveMess.save(on: req.db).map { saveMess }
                        }
                    }
                }
        }
    }
}

// MARK: - WebSocket
extension MessageController {
    
    // Broadcast message for all user in-chat (observer by chat id)
    func broadcastMessage(req: Request, mess: Message, typeName: String) {
        let responMessage = Message.GetFull(
            id: mess.id!.uuidString,
            chatID: mess.chatID!.uuidString,
            senderID: mess.senderID.uuidString,
            typeID: mess.typeID.uuidString,
            content: mess.content,
            typeName: typeName,
            createAt: mess.createdAt?.description
        )
        // Send to inchat (messages)
        SessionManager.shared.send(message: responMessage, to: .id(mess.chatID!.uuidString))
        // Send to Chats
        broadcastChat(req: req, chatID: mess.chatID!.uuidString)
    }
    
    // Broadcast chat for users in this chat
    // Chat may be new or created before but just update because hold new message
    func broadcastChat(req: Request, chatID: String) {
                
        let sqlQuery = SQLQueryString("SELECT c.id, c.first_user as \"firstUserID\", c.second_user as \"secondUserID\", u1.displayname as \"firstUserName\", u1.avatar as \"firstUserPhoto\", u2.displayname as \"secondUserName\", u2.avatar as \"secondUserPhoto\", m.content as \"messageContent\", m.created_at as \"messageCreateAt\", mt.name  as \"messageTypeName\" from chat as c, public.user as u1, public.user as u2, message as m, message_type as mt where c.first_user = u1.id and c.second_user = u2.id and m.chat_id = c.id and m.type_id = mt.id and m.id in (select m2.id from message as m2 order by created_at desc limit 1) and c.id = '\(raw: chatID)'");
        
        let db = req.db as! SQLDatabase
        _ = db.raw(sqlQuery)
            .first(decoding: Chat.GetFull.self)
            .map { (chat) in
                // Send to inchat
                if let c = chat {
                    SessionManager.shared.send(message: c, to: .id("chats\(c.firstUserID)"))
                    SessionManager.shared.send(message: c, to: .id("chats\(c.secondUserID)"))
                }
            }
    }
}
