//
//  CreatePost.swift
//  
//
//  Created by Phucnh on 10/18/20.
//

import Fluent
import FluentPostgresDriver

struct CreatePost: Migration {
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        let post = Post()
        let defaultValue = SQLColumnConstraintAlgorithm.default(0)
        
        return database.schema(Post.schema)
            .id()
            .field(post.$authorID.key, .uuid, .references(User.schema, "id"))
            .field(post.$categoryID.key, .uuid, .references(Category.schema, "id"))
            .field(post.$quote.key, .string)
            .field(post.$content.key, .string)
            .field(post.$photo.key, .string)
            .field(post.$numHeart.key, .int, .sql(defaultValue))
            .field(post.$numBreakHeart.key, .int, .sql(defaultValue))
            .field(post.$numComment.key, .int, .sql(defaultValue))
            .field("created_at", .datetime)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(Post.schema).delete()
    }
}
