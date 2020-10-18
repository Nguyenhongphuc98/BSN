//
//  Reaction.swift
//  
//
//  Created by Phucnh on 10/18/20.
//

import Fluent
import Vapor

final class Reaction: Model {
    
    static let schema = "reaction"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "user_id")
    var userID: User.IDValue
    
    @Field(key: "post_id")
    var postID: Post.IDValue
    
    @Field(key: "is_heart")
    var isHeart: Bool
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    init() { }
}

extension Reaction: Content { }
