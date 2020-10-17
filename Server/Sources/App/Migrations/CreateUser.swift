//
//  CreateUser.swift
//  
//
//  Created by Phucnh on 10/16/20.
//
import Fluent
import Foundation

struct CreateUser: Migration {
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("user")
            .id()
            //.field("username", .string, .required)
            .field("displayname", .string, .required)
            .field("avatar", .string)
            .field("cover", .string)
            .field("location", .string)
            .field("about", .string)
            .field("account_id", .uuid, .required, .references("account", "id"))
            .field("create_at", .datetime)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("user").delete()
    }
}
