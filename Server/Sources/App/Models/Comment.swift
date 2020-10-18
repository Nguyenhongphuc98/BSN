//
//  Comment.swift
//  
//
//  Created by Phucnh on 10/18/20.
//

import Fluent
import Vapor

final class Comment: Model {
    
    static let schema = "comment"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "user_id")
    var userID: User.IDValue
    
    @Field(key: "post_id")
    var postID: Post.IDValue
    
    @Field(key: "parent_id")
    var parentID: UUID
    
    @Field(key: "content")
    var content: String
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    init() { }
}

extension Comment: Content { }
