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
        let book = Book()
        let defaultRating = SQLColumnConstraintAlgorithm.default(0)
        let defaultConfirmed = SQLColumnConstraintAlgorithm.default(false)
        
        return database.schema(Book.schema)
            .id()
            .field(book.$title.key, .string)
            .field(book.$author.key, .string)
            .field(book.$cover.key, .string)
            .field(book.$description.key, .string)
            .field(book.$categoryID.key, .uuid, .references(Category.schema, "id"))
            .field(book.$isbn.key, .string)
            .field(book.$avgRating.key, .float, .sql(defaultRating))
            .field(book.$characterRating.key, .float, .sql(defaultRating))
            .field(book.$infoRating.key, .float, .sql(defaultRating))
            .field(book.$targetRating.key, .float, .sql(defaultRating))
            .field(book.$writeRating.key, .float, .sql(defaultRating))
            .field(book.$confirmed.key, .bool, .sql(defaultConfirmed))
            .field("created_at", .datetime)
            .unique(on: book.$isbn.key)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(Book.schema).delete()
    }
}

struct AddNumReviewBook: Migration {
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        let book = Book()
        let defaultNumreview = SQLColumnConstraintAlgorithm.default(0)
        
        return database.schema(Book.schema)
            .field(book.$numReview.key, .int, .sql(defaultNumreview))
            .update()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(Book.schema)
            .deleteField(Book().$numReview.key)
            .update()
    }
}
