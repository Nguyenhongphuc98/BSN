//
//  CreateUserBook.swift
//  
//
//  Created by Phucnh on 10/19/20.
//

import Fluent
import FluentPostgresDriver

struct CreateUserBook: Migration {
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        let userBook = UserBook()
    
        return database.schema(UserBook.schema)
            .id()
            .field(userBook.$userID.key, .uuid, .references(User.schema, "id"))
            .field(userBook.$bookID.key, .uuid, .references(Book.schema, "id"))
            .field(userBook.$status.key, .string)
            .field(userBook.$state.key, .string)
            .field(userBook.$statusDes.key, .string)
            .field("created_at", .datetime)
            // user can have more than one book same id
            //.unique(on: userBook.$userID.key, userBook.$bookID.key)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(UserBook.schema).delete()
    }
}
