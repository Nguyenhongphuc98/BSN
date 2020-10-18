//
//  MessageController.swift
//  
//
//  Created by Phucnh on 10/18/20.
//

import Vapor

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
        let message = try req.content.decode(Message.self)
        return message.save(on: req.db).map { message }
    }

    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return Message.find(req.parameters.get("messageID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
}
