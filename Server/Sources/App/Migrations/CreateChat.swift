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
            .field(chat.$firstUser.key, .uuid, .references(User.schema, "id"))
            .field(chat.$secondUser.key, .uuid, .references(User.schema, "id"))
            .field("created_at", .datetime)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(Notify.schema).delete()
    }
}
