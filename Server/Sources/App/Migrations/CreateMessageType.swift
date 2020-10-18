//
//  CreateMessageType.swift
//  
//
//  Created by Phucnh on 10/18/20.
//

import Fluent

struct CreateMessageType: Migration {
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(MessageType.schema)
            .id()
            .field("name", .string, .required)
            .unique(on: "name")
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(MessageType.schema).delete()
    }
}
