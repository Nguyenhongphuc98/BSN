//
//  CreateUserFollow.swift
//  
//
//  Created by Phucnh on 10/18/20.
//

import Fluent

struct CreateUserFollow: Migration {
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        let userFollow = UserFollow()
        
        return database.schema(UserFollow.schema)
            .id()
            .field(userFollow.$userID.key, .uuid, .references(User.schema, "id"))
            .field(userFollow.$followerID.key, .uuid, .references(User.schema, "id"))
            .field("created_at", .datetime)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(UserFollow.schema).delete()
    }
}
