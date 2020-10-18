//
//  ChatController.swift
//  
//
//  Created by Phucnh on 10/18/20.
//

import Vapor

struct ChatController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let chats = routes.grouped("api", "v1", "chats")
        chats.get(use: index)
        chats.post(use: create)
        chats.group(":chatID") { user in
            user.delete(use: delete)
        }
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
}
