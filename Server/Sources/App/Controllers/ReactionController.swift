//
//  ReactionController.swift
//  
//
//  Created by Phucnh on 10/18/20.
//

import Vapor

struct ReactionController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let reactions = routes.grouped("api", "v1", "reactions")
        reactions.get(use: index)
        reactions.post(use: create)
        reactions.group(":ID") { user in
            user.delete(use: delete)
        }
    }

    func index(req: Request) throws -> EventLoopFuture<[Reaction]> {
        return Reaction.query(on: req.db).all()
    }

    func create(req: Request) throws -> EventLoopFuture<Reaction> {
        let reaction = try req.content.decode(Reaction.self)
        return reaction.save(on: req.db).map { reaction }
    }

    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return Reaction.find(req.parameters.get("ID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
}
