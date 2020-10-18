//
//  CategoryController.swift
//  
//
//  Created by Phucnh on 10/18/20.
//

import Vapor

struct CategoryController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let categories = routes.grouped("api", "v1", "categories")
        categories.get(use: index)
        categories.post(use: create)
        categories.group(":ID") { category in
            category.delete(use: delete)
        }
    }

    func index(req: Request) throws -> EventLoopFuture<[Category]> {
        return Category.query(on: req.db).all()
    }

    func create(req: Request) throws -> EventLoopFuture<Category> {
        let category = try req.content.decode(Category.self)
        return category.save(on: req.db).map { category }
    }

    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return Category.find(req.parameters.get("ID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
}
