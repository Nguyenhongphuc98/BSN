//
//  NotifyController.swift
//  
//
//  Created by Phucnh on 10/18/20.
//

import Vapor
import Fluent
import SQLKit

struct NotifyController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let types = routes.grouped("api" ,"v1", "notifies")
        let authen = types.grouped(Account.authenticator())
//        types.get(use: index)
        authen.get(use: search)
        authen.post(use: create)
        authen.group(":notifyID") { group in
            group.delete(use: delete)
            group.put(use: update)
        }
    }

//    Nobody can get all notify in system, and it's not needed
//    func index(req: Request) throws -> EventLoopFuture<[Notify]> {
//        return Notify.query(on: req.db).all()
//    }

    func create(req: Request) throws -> EventLoopFuture<Notify> {
        let notify = try req.content.decode(Notify.self)
        return notify.save(on: req.db).map { notify }
    }
    
    func update(req: Request) throws -> EventLoopFuture<Notify> {
        
        // Authen
        _ = try req.auth.require(Account.self)
        
        return Notify
            .find(req.parameters.get("notifyID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { (notify)  in
                let newNotify = try! req.content.decode(Notify.Update.self)
                notify.seen = newNotify.seen
                return notify.update(on: req.db).map { notify }
            }
    }

    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return Notify.find(req.parameters.get("notifyID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
    
    func search(req: Request) throws -> EventLoopFuture<[Notify.GetFull]> {
        
        guard let page: Int = req.query["page"] else {
            throw Abort(.badRequest)
        }
        
        var per = BusinessConfig.newestNotifyLimit
        if let p: Int = req.query["per"] {
            per = p
        }
        
        let offset = page * per
        
        // Authen
        let account = try req.auth.require(Account.self)
        
        // Determine current user
        // Then get all notify of its
        return User.query(on: req.db)
            .filter(\.$accountID == account.id!)
            .first()
            .unwrap(or: Abort(.notFound))
            .flatMap { (u)  in
                
                let sqlQuery = SQLQueryString("SELECT n.notify_type_id as \"notifyTypeID\", n.actor_id as \"actorID\", n.receiver_id as \"receiverID\", n.destination_id as \"destionationID\", n.created_at as \"createdAt\", n.id, u.displayname as \"actorName\", u.avatar as \"actorPhoto\", nt.name as \"notifyName\", n.seen from notify as n, public.user as u, notify_type as nt where n.actor_id = u.id and n.notify_type_id = nt.id and n.receiver_id = '\(raw: u.id!.uuidString)' order by n.created_at desc limit \(raw: per.description) offset \(raw: offset.description)")
                
                let db = req.db as! SQLDatabase
                return db.raw(sqlQuery)
                    .all(decoding: Notify.GetFull.self)
            }
    }
}
