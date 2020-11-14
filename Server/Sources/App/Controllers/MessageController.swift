//
//  MessageController.swift
//  
//
//  Created by Phucnh on 10/18/20.
//

import Vapor
import Fluent

struct MessageController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let messages = routes.grouped("api", "v1", "messages")
        messages.get(use: index)
        messages.post(use: create)
        messages.group(":messageID") { user in
            user.delete(use: delete)
        }
    }

    func index(req: Request) throws -> EventLoopFuture<[Message]> {
        return Message.query(on: req.db).all()
    }

    func create(req: Request) throws -> EventLoopFuture<Message> {
        let message = try req.content.decode(Message.Create.self)
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
                            .filter(\.$firstUser == UUID(uuidString: message.senderID)!)
                            .filter(\.$secondUser == UUID(uuidString: message.receiverID!)!)
                    }
                    .group(.and) { (and) in
                        and
                            .filter(\.$firstUser == UUID(uuidString: message.receiverID!)!)
                            .filter(\.$secondUser == UUID(uuidString: message.senderID)!)
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
}
