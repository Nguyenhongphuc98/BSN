//
//  CreateReaction.swift
//  
//
//  Created by Phucnh on 10/18/20.
//

import Fluent

struct CreateReaction: Migration {
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        let reaction = Reaction()
        
        return database.schema(Reaction.schema)
            .id()
            .field(reaction.$userID.key, .uuid, .references(User.schema, "id"))
            .field(reaction.$postID.key, .uuid, .references(Post.schema, "id"))
            .field(reaction.$isHeart.key, .bool)
            .field("created_at", .datetime)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(Reaction.schema).delete()
    }
}
