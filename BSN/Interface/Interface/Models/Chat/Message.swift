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
class Message: ObservableObject, Identifiable {
    
    var id: String?
    
    var senderID: String
    
    var receiverID: String
    
    var createDate: Date
    
    var type: MessageType
    
    var status: MessageStatus
    
    var content: String?
    
    var sticker: String?
    
    var photo: Data?
    
    init() {
        id = kUndefine
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
    
    convenience init(sender: String, receiver: String, content: String, type: MessageType) {
        self.init(sender: sender, receiver: receiver, type: type)
        self.content = content
    }
    
    convenience init(sender: String, receiver: String, sticker: String, type: MessageType) {
        self.init(sender: sender, receiver: receiver, type: type)
        self.sticker = sticker
    }
    
    convenience init(sender: String, receiver: String, photo: Data, type: MessageType) {
        self.init(sender: sender, receiver: receiver, type: type)
        self.photo = photo
    }
    
    func isSendByMe() -> Bool {
        senderID == AppManager.shared.currenUID
    }
}
