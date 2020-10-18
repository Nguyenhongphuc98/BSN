//
//  CreateNotify.swift
//  
//
//  Created by Phucnh on 10/18/20.
//

import Fluent

struct CreateNotify: Migration {
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        let notify = Notify()
        
        return database.schema(Notify.schema)
            .id()
            .field(notify.$notifyTypeID.key, .uuid, .references(NotifyType.schema, "id"))
            .field(notify.$actorID.key, .uuid, .references(User.schema, "id"))
            .field(notify.$receiverID.key, .uuid, .references(User.schema, "id"))
            .field(notify.$destionationID.key, .uuid)
            .field("created_at", .datetime)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(Notify.schema).delete()
    }
}
