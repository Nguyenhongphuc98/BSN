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
    var firstUser: User.IDValue
    
    @Field(key: "second_user")
    var secondUser: User.IDValue
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    init() { }
}

extension Chat: Content { }
