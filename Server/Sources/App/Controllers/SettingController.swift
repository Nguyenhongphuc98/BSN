//
//  SettingController.swift
//  
//
//  Created by Phucnh on 10/18/20.
//

import Vapor

struct SettingController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let settings = routes.grouped("api" ,"v1", "settings")
        settings.get(use: index)
        settings.post(use: create)
        settings.group(":settingID") { setting in
            setting.delete(use: delete)
        }
    }

    func index(req: Request) throws -> EventLoopFuture<[Setting]> {
        return Setting.query(on: req.db).all()
    }

    func create(req: Request) throws -> EventLoopFuture<Setting> {
        let setting = try req.content.decode(Setting.self)
        return setting.save(on: req.db).map { setting }
    }

    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return Setting.find(req.parameters.get("settingID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
}
