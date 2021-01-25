//
//  NotifyController.swift
//  
//
//  Created by Phucnh on 10/18/20.
//

import Vapor
import Fluent
import SQLKit
import APNS

struct NotifyController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let types = routes.grouped("api" ,"v1", "notifies")
        let authen = types.grouped(Account.authenticator())
//        types.get(use: index)
        authen.get(use: search)
//        authen.post(use: create)
        authen.group(":notifyID") { group in
            group.delete(use: delete)
            group.put(use: update)
        }
    }

//    Nobody can get all notify in system, and it's not needed
//    func index(req: Request) throws -> EventLoopFuture<[Notify]> {
//        return Notify.query(on: req.db).all()
//    }

//    func create(req: Request) throws -> EventLoopFuture<Notify> {
//        let notify = try req.content.decode(Notify.self)
//        return notify.save(on: req.db).map { notify }
//    }
    
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

// MARK: - Core func
extension NotifyController {
    static func create(req: Request, notify: Notify) {
        _ = notify.save(on: req.db).map { _ -> Notify in 
            NotifyController.broadcast(req: req, notify: notify)
            return notify
        }
    }
}

// MARK: - WebSocket + Push notifications
extension NotifyController {
    static func broadcast(req: Request, notify: Notify) {
        
        // Get saved notify with full info to notify
        let sqlQuery = SQLQueryString("SELECT n.notify_type_id as \"notifyTypeID\", n.actor_id as \"actorID\", n.receiver_id as \"receiverID\", n.destination_id as \"destionationID\", n.created_at as \"createdAt\", n.id, u.displayname as \"actorName\", u.avatar as \"actorPhoto\", nt.name as \"notifyName\", n.seen from notify as n, public.user as u, notify_type as nt where n.actor_id = u.id and n.notify_type_id = nt.id and n.id = '\(raw: notify.id!.uuidString)'")
        
        let db = req.db as! SQLDatabase
        _ = db.raw(sqlQuery)
            .first(decoding: Notify.GetFull.self)
            .map({ n in
                if let no = n {
                    
                    SessionManager.shared.send(message: no, to: .id("notifies\(notify.receiverID)"))
                    // Incase user not open client app
                    // We have to push notifications
                    var alertBody = ""
                    let notifyType = NotifyType()
                    switch no.notifyTypeID {
                    case notifyType.heart:
                        alertBody = "\(no.actorName) đã thả tim bài viết của bạn"
                    case notifyType.breakHeart:
                        alertBody = "\(no.actorName) đã thả trái tim tan vỡ bài viết của bạn"
                    case notifyType.comment:
                        alertBody = "\(no.actorName) đã bình luận bài viết bạn đang theo dõi"
                    case notifyType.requestFollow:
                        alertBody = "\(no.actorName) đã theo dõi bạn"
                    case notifyType.borrow:
                        alertBody = "\(no.actorName) đã gửi cho bạn lời mời mượn sách"
                    case notifyType.borrowFail:
                        alertBody = "\(no.actorName) đã từ chối lời mượn sách của bạn"
                    case notifyType.borrowSuccess:
                        alertBody = "\(no.actorName) đã đồng ý lời mượn sách của bạn"
                    case notifyType.exchange:
                        alertBody = "\(no.actorName) đã gửi cho bạn yêu cầu đổi sách"
                    case notifyType.exchangeFail:
                        alertBody = "\(no.actorName) đã từ chối yêu cầu đổi sách của bạn"
                    case notifyType.exchangeSuccess:
                        alertBody = "\(no.actorName) đã chấp nhận yêu cầu đổi sách của bạn"
                    default:
                        alertBody = "Bạn có thông báo mới"
                    }
                    
                    // Notifies is not essential to make sound, so let it nil
                    let payload = APNSwiftPayload(alert: .init(body: alertBody))
                    req.apns.send(payload, to: notify.receiverID, db: req.db)
                }
            })
    }
}
