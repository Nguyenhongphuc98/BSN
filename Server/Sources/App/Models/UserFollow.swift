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

extension UserFollow {
    
    struct GetFull: Content {
        var id: String
        
        var userID: String?
        var userName: String?
        var userPhoto: String?
        
        var followerID: String?
        var followerName: String?
        var followerPhoto: String?
    }
}
