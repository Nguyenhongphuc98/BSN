//
//  UserFollowController.swift
//  
//
//  Created by Phucnh on 10/18/20.
//
import Vapor

struct UserFollowController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let userFollows = routes.grouped("api", "v1", "userFollows")
        userFollows.get(use: index)
        userFollows.post(use: create)
        userFollows.group(":ID") { user in
            user.delete(use: delete)
        }
    }

    func index(req: Request) throws -> EventLoopFuture<[UserFollow]> {
        return UserFollow.query(on: req.db).all()
    }

    func create(req: Request) throws -> EventLoopFuture<UserFollow> {
        let uf = try req.content.decode(UserFollow.self)
        return uf.save(on: req.db).map { uf }
    }

    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return UserFollow.find(req.parameters.get("ID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
}
