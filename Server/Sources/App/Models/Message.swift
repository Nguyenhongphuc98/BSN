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
    
    @OptionalField(key: "chat_id")
    var chatID: Chat.IDValue?
    
    @Field(key: "sender_id")
    var senderID: User.IDValue
    
    @Field(key: "type_id")
    var typeID: MessageType.IDValue
    
    @Field(key: "content")
    var content: String
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    init() { }
    
    init(id: UUID? = nil, chatID: String? = nil, senderID: String, typeID: String, content: String) {
        self.id = id
        self.chatID = UUID(uuidString: chatID ?? "")
        self.senderID = UUID(uuidString: senderID)!
        self.typeID = UUID(uuidString: typeID)!
        self.content = content
    }
}

extension Message: Content { }

extension Message {
    
    struct Create: Content {
        
        enum MessageType: String {
            
            case sticker
            case text
            case photo
        }
        
        var id: String?
        var chatID: String?
        var senderID: String
        var typeID: String?
        var content: String
        
        var receiverID: String?
        public var typeName: String?
        
        func toMessage() -> Message {
            Message(
                chatID: self.chatID,
                senderID: self.senderID,
                typeID: getTypeID(),
                content: self.content
            )
        }
        
        func getTypeID() -> String {
            switch self.typeName {
            case MessageType.sticker.rawValue:
                return "7F360E9F-FF0F-4F48-9209-1BD4C8783DF3"
            case MessageType.photo.rawValue:
                return "5D2161DB-308F-42B9-8C81-140E64FB966C"
            case MessageType.text.rawValue:
                return "1D15266A-1BD4-412A-BAB9-BEF93ED58413"
            default:
                return "1D15266A-1BD4-412A-BAB9-BEF93ED58413"
            }
        }
    }
}
