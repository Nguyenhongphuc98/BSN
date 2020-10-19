//
//  CreateBook.swift
//  
//
//  Created by Phucnh on 10/19/20.
//

import Fluent
import FluentPostgresDriver

struct CreateBook: Migration {
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        let post = Book()
        let defaultRating = SQLColumnConstraintAlgorithm.default(0)
        let defaultConfirmed = SQLColumnConstraintAlgorithm.default(false)
        
        return database.schema(Book.schema)
            .id()
            .field(post.$title.key, .string)
            .field(post.$author.key, .string)
            .field(post.$cover.key, .string)
            .field(post.$description.key, .string)
            .field(post.$categoryID.key, .uuid, .references(Category.schema, "id"))
            .field(post.$isbn.key, .string)
            .field(post.$avgRating.key, .float, .sql(defaultRating))
            .field(post.$characterRating.key, .float, .sql(defaultRating))
            .field(post.$infoRating.key, .float, .sql(defaultRating))
            .field(post.$targetRating.key, .float, .sql(defaultRating))
            .field(post.$writeRating.key, .float, .sql(defaultRating))
            .field(post.$confirmed.key, .bool, .sql(defaultConfirmed))
            .field("created_at", .datetime)
            .unique(on: post.$isbn.key)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(Book.schema).delete()
    }
}
