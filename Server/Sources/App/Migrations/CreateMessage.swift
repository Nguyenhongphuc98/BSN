//
//  CreateMessage.swift
//  
//
//  Created by Phucnh on 10/18/20.
//

import Fluent

struct CreateMessage: Migration {
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        let message = Message()
        return database.schema(Message.schema)
            .id()
            .field(message.$chatID.key, .uuid, .references(Chat.schema, "id"))
            .field(message.$senderID.key, .uuid, .references(User.schema, "id"))
            .field(message.$typeID.key, .uuid, .references(MessageType.schema, "id"))
            .field(message.$content.key, .string)
            .field("created_at", .datetime)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(Message.schema).delete()
    }
}
