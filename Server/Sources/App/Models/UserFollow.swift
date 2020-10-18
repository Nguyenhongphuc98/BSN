//
//  UserFollow.swift
//  
//
//  Created by Phucnh on 10/18/20.
//

import Fluent
import Vapor

final class UserFollow: Model {
    
    static let schema = "user_follow"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "user_id")
    var userID: User.IDValue
    
    @Field(key: "follower_id")
    var followerID: User.IDValue
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    init() { }
}

extension UserFollow: Content { }
