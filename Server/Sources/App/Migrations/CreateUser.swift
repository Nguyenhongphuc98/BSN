//
//  CreateUser.swift
//  
//
//  Created by Phucnh on 10/16/20.
//
import Fluent

struct CreateUser: Migration {
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        let user = User()
        
        return database.schema(User.schema)
            .id()
            //.field("username", .string, .required)
            .field(user.$displayname.key, .string, .required)
            .field(user.$avatar.key, .string)
            .field(user.$cover.key, .string)
            .field(user.$location.key, .string)
            .field(user.$about.key, .string)
            .field(user.$accountID.key, .uuid, .required, .references(Account.schema, "id"))
            .field("create_at", .datetime)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(User.schema).delete()
    }
}
