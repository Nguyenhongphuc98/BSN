//
//  CreateChat.swift
//  
//
//  Created by Phucnh on 10/18/20.
//

import Fluent

struct CreateChat: Migration {
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        let chat = Chat()
        
        return database.schema(Chat.schema)
            .id()
            .field(chat.$firstUserID.key, .uuid, .references(User.schema, "id"))
            .field(chat.$secondUserID.key, .uuid, .references(User.schema, "id"))
            .field("created_at", .datetime)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(Chat.schema).delete()
    }
}
