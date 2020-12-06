//
//  UserCategoryController.swift
//  
//
//  Created by Phucnh on 10/18/20.
//

import Vapor
import Fluent

struct UserCategoryController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let userCategories = routes.grouped("api", "v1", "userCategories")
        let authen = userCategories.grouped(Account.authenticator())
        authen.get(use: index)
        authen.post(use: create)
        authen.group(":ID") { user in
            user.delete(use: delete)
        }
        
        authen.get("user", ":ID", use: getCategory)
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
    
    // When get to setings we need get full info after joined
    func getCategory(req: Request) throws -> EventLoopFuture<[UserCategory.GetFull]> {
        
        // Authen
        let account = try req.auth.require(Account.self)
        
        // Determine current user
        return User.query(on: req.db)
            .filter(\.$accountID == account.id!)
            .first()
            .unwrap(or: Abort(.notFound))
            .flatMap { (user)  in
                
                Category.query(on: req.db)
                    .all()
                    .flatMapEach(on: req.eventLoop) { (c)  in
                        
                        return UserCategory.query(on: req.db)
                            .filter(\.$categoryID == c.id!)
                            .first()
                            .map { uc in
                                return UserCategory.GetFull(
                                    userID: user.id!.uuidString,
                                    categoryID: c.id!.uuidString,
                                    categoryName: c.name,
                                    interested: uc == nil ? false : true
                                )
                            }
                    }
            }
    }
}
