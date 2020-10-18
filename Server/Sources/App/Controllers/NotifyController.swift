//
//  NotifyController.swift
//  
//
//  Created by Phucnh on 10/18/20.
//

import Fluent
import Vapor

struct NotifyController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let types = routes.grouped("api","v1","notifies")
        types.get(use: index)
        types.post(use: create)
        types.group(":notifyID") { type in
            type.delete(use: delete)
        }
    }

    func index(req: Request) throws -> EventLoopFuture<[Notify]> {
        return Notify.query(on: req.db).all()
    }

    func create(req: Request) throws -> EventLoopFuture<Notify> {
        let notify = try req.content.decode(Notify.self)
        return notify.save(on: req.db).map { notify }
    }

    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return Notify.find(req.parameters.get("notifyID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
}
