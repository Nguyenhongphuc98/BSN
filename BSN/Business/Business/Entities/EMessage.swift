//
//  EMessage.swift
//  Business
//
//  Created by Phucnh on 11/13/20.
//

public struct EMessage: Codable {
    
    public var id: String?
    public var chatID: String?
    public var senderID: String
    public var typeID: String?
    public var content: String
    
    public var receiverID: String?
    public var typeName: String?
    public var createAt: String?
        
    public init() {
        self.id = "undefine"
        self.chatID = "undefine"
        self.senderID = "undefine"
        self.typeID = "undefine"
        self.content = "undefine"
        self.createAt = "undefine"
    }
    
    public init(chatID: String? = nil, senderID: String, typeName: String, content: String, receiverID: String) {
        // In case this is first message
        // We have to know sender and receiver to create Chat room
        self.chatID = chatID
        self.senderID = senderID
        self.typeName = typeName
        self.content = content
        self.receiverID = receiverID
    }
}
