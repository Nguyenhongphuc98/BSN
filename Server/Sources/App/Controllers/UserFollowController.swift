//
//  UserFollowController.swift
//  
//
//  Created by Phucnh on 10/18/20.
//
import Vapor
import SQLKit

struct UserFollowController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let userFollows = routes.grouped("api", "v1", "userFollows")
        userFollows.get(use: index)
        userFollows.post(use: create)
        userFollows.group(":ID") { user in
            user.delete(use: delete)
        }
        
        userFollows.get("following", use: searchFollowing)
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
    
    // Search users current following
    func searchFollowing(req: Request) throws -> EventLoopFuture<[UserFollow.GetFull]> {
        
        guard let uid: String = req.query["uid"], let term: String = req.query["term"] else {
            throw Abort(.badRequest)
        }
        
        let limit = String(describing: BusinessConfig.searchUserLimit)
        
        let sqlQuery = SQLQueryString("SELECT uf.id, uf.user_id as \"userID\", uf.follower_id  as \"followerID\", u.displayname as \"userName\", u.avatar as \"userPhoto\" FROM user_follow as uf, public.user as u where uf.user_id = u.id and uf.follower_id = '\(raw: uid)' and LOWER(u.displayname) LIKE LOWER('%\(raw: term)%') LIMIT \(raw: limit)")
        
        
        let db = req.db as! SQLDatabase
        return db.raw(sqlQuery)
            .all(decoding: UserFollow.GetFull.self)
    }
}
