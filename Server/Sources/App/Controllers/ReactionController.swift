//
//  ReactionController.swift
//  
//
//  Created by Phucnh on 10/18/20.
//

import Vapor
import Fluent

struct ReactionController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let reactions = routes.grouped("api", "v1", "reactions")
        let authen = reactions.grouped(Account.authenticator())
        authen.get(use: index)
        authen.post(use: create)        
        authen.delete("delete", use: delete)
    }

    func index(req: Request) throws -> EventLoopFuture<[Reaction]> {
        return Reaction.query(on: req.db).all()
    }

    func create(req: Request) throws -> EventLoopFuture<Reaction> {
        let reaction = try req.content.decode(Reaction.self)
        
        // Create have 2 case. make heart or break_heart
        // Before we create, should delete last react, update on post if we found reaction to delete
        // In same time, user-post either heart or bheart.
        // Then create new, update post
        
        // Authen
        let account = try req.auth.require(Account.self)
        
        // Determine current user
        return User.query(on: req.db)
            .filter(\.$accountID == account.id!) // Find user of this account
            .filter(\.$id == reaction.userID) // Make sure current user is owner of this reaction
            .first()
            .unwrap(or: Abort(.forbidden))
            .flatMap { (user)  in
                
                return Reaction.query(on: req.db)
                    .filter(\.$postID == reaction.postID)
                    .filter(\.$userID == reaction.userID)
                    .first()
                    .flatMap { r in
                        
                        var isHeartBefore: Bool?
                        var notifyType: String = ""
                        
                        if let react = r {
                            isHeartBefore = react.isHeart
                            _ = react.delete(on: req.db)
                        }
                        
                        // Update num heart and num break
                        _ = Post.query(on: req.db)
                            .filter(\.$id == reaction.postID)
                            .first()
                            .unwrap(or: Abort(.badRequest))
                            .map({ (p) in
                                
                                if reaction.isHeart {
                                    p.numHeart! += 1
                                    notifyType = NotifyType().heart
                                    
                                    if isHeartBefore != nil {
                                        // should update this if we found a row exist before to delete
                                        p.numBreakHeart! -= isHeartBefore! ? 0 : 1
                                    }
                                } else {
                                    p.numBreakHeart! += 1
                                    notifyType = NotifyType().breakHeart
                                    
                                    if isHeartBefore != nil {
                                        // should update this if we found a row exist before to delete
                                        p.numHeart! -= isHeartBefore! ? 1 : 0
                                    }
                                }
                                
                                // Notify to owner this post
                                // Incase react them post, we don't need to notify
                                if p.authorID != user.id! {
                                    let notify = Notify(
                                        typeID: UUID(uuidString: notifyType)!,
                                        actor: user.id!,
                                        receiver: p.authorID,
                                        des: p.id!
                                    )
                                    //_ = notify.save(on: req.db)
                                    NotifyController.create(req: req, notify: notify)
                                }                                
                                
                                _ = p.update(on: req.db)
                            })
                        
                        // Save and done job
                        return reaction.save(on: req.db).map { reaction }
                    }
            }
    }

    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        // unHeart or unBheart
        // Actualy, we don't need to care what type will be delete
        // Just do it and enjoy
        
        guard let uidStr: String = req.query["uid"],
              let uid = UUID(uuidString: uidStr),
              let pidStr: String = req.query["pid"],
              let pid = UUID(uuidString: pidStr) else {
            
            throw Abort(.badRequest)
        }
        
        // Authen
        let account = try req.auth.require(Account.self)
        
        // First, find the action of current user and that post
        return User.query(on: req.db)
            .filter(\.$accountID == account.id!) // Find user of this account
            .filter(\.$id == uid) // Make sure current user is owner of this reaction
            .first()
            .unwrap(or: Abort(.forbidden))
            .flatMap { (user)  in
                
                return Reaction.query(on: req.db)
                    .filter(\.$postID == pid)
                    .filter(\.$userID == user.id!)
                    .first()
                    .unwrap(or: Abort(.notFound))
                    .flatMap { r in
                        
                        // Update num heart and num break
                        _ = Post.query(on: req.db)
                            .filter(\.$id == r.postID)
                            .first()
                            .unwrap(or: Abort(.badRequest))
                            .map({ p in
                                if r.isHeart {
                                    p.numHeart! -= 1
                                } else {
                                    p.numBreakHeart! -= 1
                                }

                                _ = p.update(on: req.db)
                            })
                        
                        return r.delete(on: req.db).transform(to: .ok)
                    }
            }
        
//        return Reaction.find(req.parameters.get("ID"), on: req.db)
//            .unwrap(or: Abort(.notFound))
//            .flatMap { $0.delete(on: req.db) }
//            .transform(to: .ok)
    }
}
