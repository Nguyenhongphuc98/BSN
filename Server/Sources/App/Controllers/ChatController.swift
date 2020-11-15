//
//  ChatController.swift
//  
//
//  Created by Phucnh on 10/18/20.
//

import Vapor
import Fluent
import SQLKit

struct ChatController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let chats = routes.grouped("api", "v1", "chats")
        let authen = chats.grouped(Account.authenticator())
        
        authen.get(use: index)
        authen.get("newest", use: getNewest)
        authen.post(use: create)
        authen.group(":chatID") { group in
            group.delete(use: delete)
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
                let sqlQuery = SQLQueryString("SELECT c.id, c.first_user as \"firstUserID\", c.second_user as \"secondUserID\", u1.displayname as \"firstUserName\", u1.avatar as \"firstUserPhoto\", u2.displayname as \"secondUserName\", u2.avatar as \"secondUserPhoto\", m.content as \"messageContent\", m.created_at as \"messageCreateAt\", mt.name  as \"messageTypeName\" from chat as c, public.user as u1, public.user as u2, message as m, message_type as mt where (c.first_user = '\(raw: u.id!.uuidString)' or c.second_user = '\(raw: u.id!.uuidString)') and c.first_user = u1.id and c.second_user = u2.id and m.chat_id = c.id and m.type_id = mt.id and m.id in (select m2.id from message as m2 order by created_at desc limit 1) order by c.created_at desc limit \(raw: per.description) offset \(raw: offset.description)");
                
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
                let sqlQuery = SQLQueryString("SELECT c.id, c.first_user as \"firstUserID\", c.second_user as \"secondUserID\", u1.displayname as \"firstUserName\", u1.avatar as \"firstUserPhoto\", u2.displayname as \"secondUserName\", u2.avatar as \"secondUserPhoto\", m.content as \"messageContent\", m.created_at as \"messageCreateAt\", mt.name  as \"messageTypeName\" from chat as c, public.user as u1, public.user as u2, message as m, message_type as mt where ((c.first_user = '\(raw: u.id!.uuidString)' and LOWER(u2.displayname) LIKE LOWER('%\(raw: name)%')) or (c.second_user = '\(raw: u.id!.uuidString)' and LOWER(u1.displayname) LIKE LOWER('%\(raw: name)%'))) and c.first_user = u1.id and c.second_user = u2.id and m.chat_id = c.id and m.type_id = mt.id and m.id in (select m2.id from message as m2 order by created_at desc limit 1)");
                
                let db = req.db as! SQLDatabase
                return db.raw(sqlQuery)
                    .all(decoding: Chat.GetFull.self)
            }
    }
}

//SELECT c.id, c.first_user , c.second_user, u1.displayname, u1.avatar, u2.displayname, u2.avatar, m.content, m.created_at, mt.name from chat as c, public.user as u1, public.user as u2, message as m, message_type as mt where (c.first_user = 'c4285abe-f520-46f3-97a3-508d94177d9c' or c.second_user = 'c4285abe-f520-46f3-97a3-508d94177d9c') and c.first_user = u1.id and c.second_user = u2.id and m.chat_id = c.id and m.type_id = mt.id and m.id in (select m2.id from message as m2 order by created_at desc limit 1) order by c.created_at desc limit 5 offset 0;

//SELECT c.id, c.first_user as \"firstUserID\", c.second_user as \"secondUserID\", u1.displayname as \"firstUserName\", u1.avatar as \"firstUserPhoto\", u2.displayname as \"secondUserName\", u2.avatar as \"secondUserPhoto\", m.content as \"messageContent\", m.created_at as \"messageCreateAt\", mt.name  as \"messageTypeName\" from chat as c, public.user as u1, public.user as u2, message as m, message_type as mt where ((c.first_user = '\(raw: u.id!.uuidString)' and LOWER(u2.displayname) LIKE LOWER('%\(raw: name)%') or (c.second_user = '\(raw: u.id!.uuidString)' and LOWER(u1.displayname) LIKE LOWER('%\(raw: name)%')) and c.first_user = u1.id and c.second_user = u2.id and m.chat_id = c.id and m.type_id = mt.id and m.id in (select m2.id from message as m2 order by created_at desc limit 1)
