//
//  CreateNotifyType.swift
//  
//
//  Created by Phucnh on 10/17/20.
//

import Fluent

struct CreateNotifyType: Migration {
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        
        let type = NotifyType()
        return database.schema(NotifyType.schema)
            .id()
            .field(type.$name.key, .string, .required)
            .unique(on: type.$name.key)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(NotifyType.schema).delete()
    }
}
