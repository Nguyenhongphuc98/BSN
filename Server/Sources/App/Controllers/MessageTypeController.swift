//
//  MessageTypeController.swift
//  
//
//  Created by Phucnh on 10/18/20.
//


import Vapor

struct MessageTypeController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let types = routes.grouped("api" ,"v1", "messageTypes")
        types.get(use: index)
        types.post(use: create)
        types.group(":messageTypeID") { type in
            type.delete(use: delete)
        }
    }

    func index(req: Request) throws -> EventLoopFuture<[MessageType]> {
        return MessageType.query(on: req.db).all()
    }

    func create(req: Request) throws -> EventLoopFuture<MessageType> {
        let type = try req.content.decode(MessageType.self)
        return type.save(on: req.db).map { type }
    }

    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return MessageType.find(req.parameters.get("messageTypeID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
}
