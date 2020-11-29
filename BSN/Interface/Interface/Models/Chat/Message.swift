//
//  Message.swift
//  Interface
//
//  Created by Phucnh on 10/2/20.
//

import SwiftUI

enum MessageStatus {
    
    case notsent
    
    case sent
    
    case received
    
    case seen
}

enum MessageType: String {
    
    case sticker
    
    case text
    
    case photo
}

// MARK: - Message model
class Message: ObservableObject, AppendUniqueAble {
    
    var id: String?
    
    var senderID: String
    
    var receiverID: String
    
    var createDate: Date
    
    var type: MessageType
    
    var status: MessageStatus
    
    // Depent on type message, it will hold special value
    // ex text, photoUrl, sticker name
    var content: String?
    
    init(id: String? = nil) {
        self.id = id ?? kUndefine
        senderID = kUndefine
        receiverID = kUndefine
        createDate = Date()
        content = kUndefine
        status = .received
        type = .text
    }
    
    init(id: String? = nil, sender: String, receiver: String, type: MessageType) {
        self.id = id ?? UUID().uuidString
        self.senderID =  sender
        self.receiverID = receiver
        self.createDate = Date()
        self.status = .received
        self.type = type
    }
    
    // Init message send text content
    convenience init(sender: String, receiver: String, content: String, type: MessageType) {
        self.init(sender: sender, receiver: receiver, type: type)
        self.content = content
    }
    
    // Init message as last message of a chat
    convenience init(sender: String = "", content: String, type: String, createAt: String) {
        self.init(sender: sender, receiver: "", type: MessageType(rawValue: type)!)
        self.content = content
        self.createDate = Date.getDate(dateStr: createAt)
    }
    
    func isSendByMe() -> Bool {
        senderID == AppManager.shared.currenUID
    }
}
