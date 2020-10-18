//
//  CreateComment.swift
//  
//
//  Created by Phucnh on 10/18/20.
//

import Fluent

struct CreateComment: Migration {
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        let comment = Comment()
        
        return database.schema(Comment.schema)
            .id()
            .field(comment.$userID.key, .uuid, .references(User.schema, "id"))
            .field(comment.$postID.key, .uuid, .references(Post.schema, "id"))
            .field(comment.$parentID.key, .uuid) // if lv0 => equal postID
            .field(comment.$content.key, .string)
            .field("created_at", .datetime)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(Comment.schema).delete()
    }
}
