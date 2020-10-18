//
//  UserCategoryController.swift
//  
//
//  Created by Phucnh on 10/18/20.
//

import Vapor

struct UserCategoryController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let userCategories = routes.grouped("api", "v1", "userCategories")
        userCategories.get(use: index)
        userCategories.post(use: create)
        userCategories.group(":ID") { user in
            user.delete(use: delete)
        }
    }

    func index(req: Request) throws -> EventLoopFuture<[UserCategory]> {
        return UserCategory.query(on: req.db).all()
    }

    func create(req: Request) throws -> EventLoopFuture<UserCategory> {
        let uc = try req.content.decode(UserCategory.self)
        return uc.save(on: req.db).map { uc }
    }

    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return UserCategory.find(req.parameters.get("ID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
}
