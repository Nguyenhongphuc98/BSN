//
//  ChatController.swift
//  
//
//  Created by Phucnh on 10/18/20.
//

import Vapor
import Fluent
import SQLKit
import APNS

struct ChatController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let chats = routes.grouped("api", "v1", "chats")
        let authen = chats.grouped(Account.authenticator())
        
        authen.get(use: index)
        authen.get("newest", use: getNewest)
        authen.post(use: create)
        authen.group(":chatID") { group in
            group.delete(use: delete)
            group.put(use: update)
        }
        
        authen.get("search", use: getChatBaseOnUser)
        authen.get("user", use: searchChats)
    }

    func index(req: Request) throws -> EventLoopFuture<[Chat]> {
        return Chat.query(on: req.db).all()
    }

    func create(req: Request) throws -> EventLoopFuture<Chat> {
        let chat = try req.content.decode(Chat.self)
        return chat.save(on: req.db).map { chat }
    }
    
    func update(req: Request) throws -> EventLoopFuture<Chat> {
        // Authen
        let account = try req.auth.require(Account.self)
        
        // Determine current user
        return User.query(on: req.db)
            .filter(\.$accountID == account.id!)
            .first()
            .unwrap(or: Abort(.forbidden))
            .flatMap { (u)  in
                Chat
                    .find(req.parameters.get("chatID"), on: req.db)
                    .unwrap(or: Abort(.notFound))
                    .flatMap { currentChat in
                        
                        // Only seen field can update
                        let newChat = try! req.content.decode(Chat.Update.self)
                        if currentChat.firstUserID == u.id {
                            currentChat.firstUserSeen = newChat.seen
                        } else if currentChat.secondUserID == u.id {
                            currentChat.secondUserSeen = newChat.seen
                        }

                        return currentChat.update(on: req.db).map {
                            // Update seen for himself, don't need to broadcast
                            // ChatController.broadcastChat(req: req, chatID: currentChat.id!.uuidString)
                            return currentChat
                        }
                    }
            }
    }

    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return Chat.find(req.parameters.get("chatID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
    
    func getNewest(req: Request) throws -> EventLoopFuture<[Chat.GetFull]> {
        
        guard let page: Int = req.query["page"] else {
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
        // Then get all chats of its
        return User.query(on: req.db)
            .filter(\.$accountID == account.id!)
            .first()
            .unwrap(or: Abort(.notFound))
            .flatMap { (u)  in
                
                // Get chat have first or second user is current user searching
                // Get 2 users info of this chat
                // Get last message (join message type to get type name)
                let sqlQuery = SQLQueryString("SELECT c.id, c.first_user as \"firstUserID\", c.second_user as \"secondUserID\", c.first_user_seen as \"firstUserSeen\", c.second_user_seen as \"secondUserSeen\", u1.displayname as \"firstUserName\", u1.avatar as \"firstUserPhoto\", u2.displayname as \"secondUserName\", u2.avatar as \"secondUserPhoto\", m.content as \"messageContent\", m.created_at as \"messageCreateAt\", mt.name  as \"messageTypeName\" from chat as c, public.user as u1, public.user as u2, message as m, message_type as mt where (c.first_user = '\(raw: u.id!.uuidString)' or c.second_user = '\(raw: u.id!.uuidString)') and c.first_user = u1.id and c.second_user = u2.id and m.chat_id = c.id and m.type_id = mt.id and m.id = (select m2.id from message as m2 where m2.chat_id = c.id order by created_at desc limit 1) order by c.created_at desc limit \(raw: per.description) offset \(raw: offset.description)");
                
                let db = req.db as! SQLDatabase
                return db.raw(sqlQuery)
                    .all(decoding: Chat.GetFull.self)
            }
    }
    
    // Get chat where 2 user id match chat
    func getChatBaseOnUser(req: Request) throws -> EventLoopFuture<Chat> {
       
        guard let uid1: UUID = req.query["uid1"], let uid2: UUID = req.query["uid2"] else {
            throw Abort(.badRequest)
        }
        
        // Authen
        let account = try req.auth.require(Account.self)
        
        // Author
        return User.query(on: req.db)
            .filter(\.$accountID == account.id!)
            .group(.or, { (or) in
                // Searcher have to in chat to get this chat
                or.filter(\.$id == uid1).filter(\.$id == uid2)
            })
            .first()
            .unwrap(or: Abort(.forbidden))
            .flatMap { (u)  in
                    
                    // try to find chat hold this message
                    // Chat need find will have two id sender and receiver same
                    return Chat.query(on: req.db)
                        .group(.or, { (or) in
                            or.group(.and) { (and) in
                                and
                                    .filter(\.$firstUserID == uid1)
                                    .filter(\.$secondUserID == uid2)
                            }
                            .group(.and) { (and) in
                                and
                                    .filter(\.$firstUserID == uid2)
                                    .filter(\.$secondUserID == uid1)
                            }
                        })
                        .first()
                        .unwrap(or: Abort(.notFound))
                        .map { $0 }
                }
    }
    
    // Search chated by patner displayname
    func searchChats(req: Request) throws -> EventLoopFuture<[Chat.GetFull]> {
        
        guard let name: String = req.query["name"] else {
            throw Abort(.badRequest)
        }
        
        // Authen
        let account = try req.auth.require(Account.self)
        
        // Determine current user
        // Then get all notify of its
        return User.query(on: req.db)
            .filter(\.$accountID == account.id!)
            .first()
            .unwrap(or: Abort(.notFound))
            .flatMap { (u)  in
                
                // Get chat have first or second user is current user searching
                // Get 2 users info of this chat
                // Get last message (join message type to get type name)
                // This chat have partner name as query partam req
                let sqlQuery = SQLQueryString("SELECT c.id, c.first_user as \"firstUserID\", c.second_user as \"secondUserID\", c.first_user_seen as \"firstUserSeen\", c.second_user_seen as \"secondUserSeen\", u1.displayname as \"firstUserName\", u1.avatar as \"firstUserPhoto\", u2.displayname as \"secondUserName\", u2.avatar as \"secondUserPhoto\" from chat as c, public.user as u1, public.user as u2 where ((c.first_user = '\(raw: u.id!.uuidString)' and LOWER(u2.displayname) LIKE LOWER('%\(raw: name)%')) or (c.second_user = '\(raw: u.id!.uuidString)' and LOWER(u1.displayname) LIKE LOWER('%\(raw: name)%'))) and c.first_user = u1.id and c.second_user = u2.id")
                
                // Dont need to get last message and message_type
//                let sqlQuery = SQLQueryString("SELECT c.id, c.first_user as \"firstUserID\", c.second_user as \"secondUserID\", c.first_user_seen as \"firstUserSeen\", c.second_user_seen as \"secondUserSeen\", u1.displayname as \"firstUserName\", u1.avatar as \"firstUserPhoto\", u2.displayname as \"secondUserName\", u2.avatar as \"secondUserPhoto\", m.content as \"messageContent\", m.created_at as \"messageCreateAt\", mt.name  as \"messageTypeName\" from chat as c, public.user as u1, public.user as u2, message as m, message_type as mt where ((c.first_user = '\(raw: u.id!.uuidString)' and LOWER(u2.displayname) LIKE LOWER('%\(raw: name)%')) or (c.second_user = '\(raw: u.id!.uuidString)' and LOWER(u1.displayname) LIKE LOWER('%\(raw: name)%'))) and c.first_user = u1.id and c.second_user = u2.id and m.chat_id = c.id and m.type_id = mt.id and m.id = (select m2.id from message as m2 where m2.chat_id = c.id order by created_at desc limit 1)")
                
                let db = req.db as! SQLDatabase
                return db.raw(sqlQuery)
                    .all(decoding: Chat.GetFull.self)
            }
    }
}

// MARK: - WebSocket
extension ChatController {
    
    // Broadcast chat for users in this chat
    // Chat may be new or created before but just update because hold new message
    static func broadcastChat(req: Request, chatID: String, senderID: String) {
                
        let sqlQuery = SQLQueryString("SELECT c.id, c.first_user as \"firstUserID\", c.second_user as \"secondUserID\", c.first_user_seen as \"firstUserSeen\", c.second_user_seen as \"secondUserSeen\", u1.displayname as \"firstUserName\", u1.avatar as \"firstUserPhoto\", u2.displayname as \"secondUserName\", u2.avatar as \"secondUserPhoto\", m.content as \"messageContent\", m.created_at as \"messageCreateAt\", mt.name  as \"messageTypeName\" from chat as c, public.user as u1, public.user as u2, message as m, message_type as mt where c.first_user = u1.id and c.second_user = u2.id and m.chat_id = c.id and m.type_id = mt.id and m.id = (select m2.id from message as m2 where m2.chat_id = c.id order by created_at desc limit 1) and c.id = '\(raw: chatID)'");
        
        let db = req.db as! SQLDatabase
        _ = db.raw(sqlQuery)
            .first(decoding: Chat.GetFull.self)
            .map { (chat) in
                // Send to inchat
                if let c = chat {
                    SessionManager.shared.send(message: c, to: .id("chats\(c.firstUserID)"))
                    SessionManager.shared.send(message: c, to: .id("chats\(c.secondUserID)"))
                    
                    // Push notify to receiver
                    let senderName = senderID == c.firstUserID ? c.firstUserName : c.secondUserName
                    let receiverID = senderID == c.firstUserID ? c.secondUserID : c.firstUserID
                    let payload = APNSwiftPayload(alert: .init(title: senderName,
                                                              body: c.messageContent),
                                                  sound: .normal("default"))
                    req.apns.send(payload, to: UUID(uuidString: receiverID)!, db: req.db)
                }
            }
    }
}

// Get Recently chat
//SELECT c.id, c.first_user as "firstUserID", c.second_user as "secondUserID", c.first_user_seen as "firstUserSeen", c.second_user_seen as "secondUserSeen", u1.displayname as "firstUserName", u1.avatar as "firstUserPhoto", u2.displayname as "secondUserName", u2.avatar as "secondUserPhoto", m.content as "messageContent", m.created_at as "messageCreateAt", mt.name  as "messageTypeName" from chat as c, public.user as u1, public.user as u2, message as m, message_type as mt where (c.first_user = 'C4285ABE-F520-46F3-97A3-508D94177D9C' or c.second_user = 'C4285ABE-F520-46F3-97A3-508D94177D9C') and c.first_user = u1.id and c.second_user = u2.id and m.chat_id = c.id and m.type_id = mt.id and m.id in (select m2.id from message as m2 where m2.chat_id = c.id order by created_at desc limit 1) order by c.created_at desc limit 8 offset 0

// Serch short info of chat by parter
//SELECT c.id, c.first_user as "firstUserID", c.second_user as "secondUserID", c.first_user_seen as "firstUserSeen", c.second_user_seen as "secondUserSeen", u1.displayname as "firstUserName", u1.avatar as "firstUserPhoto", u2.displayname as "secondUserName", u2.avatar as "secondUserPhoto" from chat as c, public.user as u1, public.user as u2 where ((c.first_user = 'c4285abe-f520-46f3-97a3-508d94177d9c' and LOWER(u2.displayname) LIKE LOWER('%H%')) or (c.second_user = 'c4285abe-f520-46f3-97a3-508d94177d9c' and LOWER(u1.displayname) LIKE LOWER('%h%'))) and c.first_user = u1.id and c.second_user = u2.id;
