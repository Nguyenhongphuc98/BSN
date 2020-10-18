//
//  CreateNotifyType.swift
//  
//
//  Created by Phucnh on 10/17/20.
//

import Fluent

struct CreateNotifyType: Migration {
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(NotifyType.schema)
            .id()
            .field("name", .string, .required)
            .unique(on: "name")
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(NotifyType.schema).delete()
    }
}
