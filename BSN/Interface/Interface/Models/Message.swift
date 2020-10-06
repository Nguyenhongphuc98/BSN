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

enum MessageType {
    
    case sticker
    
    case text
    
    case photo
}

// MARK: - Message model
class Message: ObservableObject, Identifiable {
    
    var id: String
    
    var sender: User
    
    var receiver: User
    
    var createDate: Date
    
    var type: MessageType
    
    var status: MessageStatus
    
    var content: String?
    
    var sticker: String?
    
    var photo: Data?
    
    init() {
        id = UUID().uuidString
        sender =  Int.random(in: 0..<2) == 0 ? User() : AppManager.shared.currentUser
        
        receiver = AppManager.shared.currentUser
        createDate = randomDate()
        content = randomMessage()
        status = .received
        
        if Int.random(in: 0..<2) == 0 {
            type = .sticker
            sticker = stickers.randomElement()
        } else {
            type = .text
        }
        
    }
    
    init(sender: User, receiver: User, status: MessageStatus = .notsent, type: MessageType) {
        id = UUID().uuidString
        self.sender =  sender
        self.receiver = receiver
        self.createDate = Date()
        self.status = status
        self.type = type
    }
    
    convenience init(sender: User, receiver: User, content: String, status: MessageStatus = .notsent, type: MessageType) {
        self.init(sender: sender, receiver: receiver, status: status, type: type)
        self.content = content
    }
    
    convenience init(sender: User, receiver: User, sticker: String, status: MessageStatus = .notsent, type: MessageType) {
        self.init(sender: sender, receiver: receiver, status: status, type: type)
        self.sticker = sticker
    }
    
    convenience init(sender: User, receiver: User, photo: Data, status: MessageStatus = .notsent, type: MessageType) {
        self.init(sender: sender, receiver: receiver, status: status, type: type)
        self.photo = photo
    }
    
    func isSendByMe() -> Bool {
        sender.username == AppManager.shared.currentUser.username
    }
}
