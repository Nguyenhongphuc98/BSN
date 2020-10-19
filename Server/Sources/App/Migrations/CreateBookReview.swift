//
//  CreateBookReview.swift
//  
//
//  Created by Phucnh on 10/19/20.
//

import Fluent
import FluentPostgresDriver

struct CreateBookReview: Migration {
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        let bookReview = BookReview()
        let defaultRating = SQLColumnConstraintAlgorithm.default(0)
        
        return database.schema(BookReview.schema)
            .id()
            .field(bookReview.$userID.key, .uuid, .references(User.schema, "id"))
            .field(bookReview.$bookID.key, .uuid, .references(Book.schema, "id"))
            .field(bookReview.$title.key, .string)
            .field(bookReview.$description.key, .string)
            .field(bookReview.$characterRating.key, .float, .sql(defaultRating))
            .field(bookReview.$infoRating.key, .float, .sql(defaultRating))
            .field(bookReview.$targetRating.key, .float, .sql(defaultRating))
            .field(bookReview.$writeRating.key, .float, .sql(defaultRating))
            .field("created_at", .datetime)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(BookReview.schema).delete()
    }
}
