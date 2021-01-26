//
//  AdminController.swift
//  
//
//  Created by Phucnh on 1/26/21.
//


import Vapor
import Fluent

// View in webbrowser
struct AdminController: RouteCollection {
    
    static var adminUID = UUID("98646848-D6BF-404E-BAA4-6781529E65F3")!
    
    func boot(routes: RoutesBuilder) throws {
        let admin = routes.grouped("admin")
        
        //admin.get("login", use: login)
        admin.get("notifies", use: notifies)
        admin.post("makenotify", use: makeNotify)
    }
    
    // Base function
//    func login(req: Request) throws -> EventLoopFuture<[Book]> {
//        return Book.query(on: req.db).all()
//    }
//
    func makeNotify(req: Request) throws -> EventLoopFuture<Response> {
        let notify = try req.content.decode(Notify.CreateForAll.self)
        return User.query(on: req.db)
            .all()
            .map { (users) -> Response in
                
                _ = users.map({ u in
                    let n = Notify(
                        typeID: UUID(NotifyType().adminNotify)!,
                        actor: AdminController.adminUID,
                        receiver: u.id!,
                        des: u.id!, // we don't user this field because nav to notify View
                        title: notify.title,
                        content: notify.content
                    )
                    
                    NotifyController.create(req: req, notify: n)
                })
                
                return req.redirect(to: "/admin/notifies")
            }
    }
    
    func notifies(req: Request) throws -> EventLoopFuture<View> {
        
        return Notify.query(on: req.db)
            .filter(\.$actorID == AdminController.adminUID)
            .sort(\.$createdAt, .descending)
            .all()
            .flatMap { (ns) -> EventLoopFuture<View> in
                
                var nss = [Notify]()
                ns.forEach { (n) in
                    // Filter duplicate when send for mutil users
                    if nss.isEmpty {
                        nss.append(n)
                    } else {
                        if !(nss.last!.content == n.content && nss.last!.title == n.title) {
                            nss.append(n)
                        }
                    }
                }
                let notifies = NotifyContext(notifies: nss)
                return req.view.render("notifies", notifies)
            }
    }
}

struct NotifyContext: Encodable {
    var notifies: [Notify]
}
