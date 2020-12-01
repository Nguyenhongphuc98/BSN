//
//  CreateChat.swift
//  
//
//  Created by Phucnh on 10/18/20.
//

import Fluent
import FluentPostgresDriver

struct CreateChat: Migration {
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        let chat = Chat()
        let defaultSeen = SQLColumnConstraintAlgorithm.default(false)
        
        return database.schema(Chat.schema)
            .id()
            .field(chat.$firstUserID.key, .uuid, .references(User.schema, "id"))
            .field(chat.$secondUserID.key, .uuid, .references(User.schema, "id"))
            .field(chat.$firstUserSeen.key, .bool, .sql(defaultSeen))
            .field(chat.$secondUserSeen.key, .bool, .sql(defaultSeen))
            .field("created_at", .datetime)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(Chat.schema).delete()
    }
}

//struct UpdateChat: Migration {
//
//    func prepare(on database: Database) -> EventLoopFuture<Void> {
//        let chat = Chat()
//        let defaultSeen = SQLColumnConstraintAlgorithm.default(false)
//
//        return database.schema(Chat.schema)
//            .field(chat.$firstUserSeen.key, .bool, .sql(defaultSeen))
//            .field(chat.$secondUserSeen.key, .bool, .sql(defaultSeen))
//            .update()
//    }
//
//    func revert(on database: Database) -> EventLoopFuture<Void> {
//        return database.schema(Chat.schema).delete()
//    }
//}
