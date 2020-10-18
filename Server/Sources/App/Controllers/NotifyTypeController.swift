//
//  NotifyTypeController.swift
//  
//
//  Created by Phucnh on 10/17/20.
//

import Fluent
import Vapor

struct NotifyTypeController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let types = routes.grouped("notifyTypes")
        types.get(use: index)
        types.post(use: create)
        types.group(":typeID") { type in
            type.delete(use: delete)
        }
    }

    func index(req: Request) throws -> EventLoopFuture<[NotifyType]> {
        return NotifyType.query(on: req.db).all()
    }

    func create(req: Request) throws -> EventLoopFuture<NotifyType> {
        let type = try req.content.decode(NotifyType.self)
        return type.save(on: req.db).map { type }
    }

    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return NotifyType.find(req.parameters.get("typeID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
}
