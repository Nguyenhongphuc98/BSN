//
//  Message.swift
//  
//
//  Created by Phucnh on 10/18/20.
//

import Fluent
import Vapor

final class Message: Model {
    
    static let schema = "message"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "chat_id")
    var chatID: Chat.IDValue
    
    @Field(key: "sender_id")
    var senderID: User.IDValue
    
    @Field(key: "type_id")
    var typeID: MessageType.IDValue
    
    @Field(key: "content")
    var content: String
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    init() { }
}

extension Message: Content { }
