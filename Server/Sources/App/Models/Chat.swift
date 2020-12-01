//
//  Chat.swift
//  
//
//  Created by Phucnh on 10/18/20.
//

import Fluent
import Vapor

final class Chat: Model {
    
    static let schema = "chat"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "first_user")
    var firstUserID: User.IDValue
    
    @Field(key: "second_user")
    var secondUserID: User.IDValue
    
    @Field(key: "first_user_seen")
    var firstUserSeen: Bool?
    
    @Field(key: "second_user_seen")
    var secondUserSeen: Bool?
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    init() { }
    
    init(firstUid: String, secondUid: String) {
        self.firstUserID = UUID(uuidString: firstUid)!
        self.secondUserID = UUID(uuidString: secondUid)!
    }
}

extension Chat: Content { }

extension Chat {
    
    struct GetFull: Content {
        var id: String?
        var firstUserID: String
        var secondUserID: String
        var firstUserSeen: Bool
        var secondUserSeen: Bool
        
        // User info
        var firstUserName: String?
        var firstUserPhoto: String?
        var secondUserName: String?
        var secondUserPhoto: String?
        
        // Last message
        var messageContent: String?
        var messageCreateAt: String?
        var messageTypeName: String?
    }
}
