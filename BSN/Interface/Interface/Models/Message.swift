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
    
    var content: String
    
    var type: MessageType
    
    var status: MessageStatus
    
    init() {
        id = UUID().uuidString
        sender =  Int.random(in: 0..<2) == 0 ? User() : RootViewModel.shared.currentUser
        
        receiver = RootViewModel.shared.currentUser
        createDate = randomDate()
        content = randomMessage()
        status = .received
        type = .text
    }
    
    init(sender: User, receiver: User, content: String, status: MessageStatus = .notsent, type: MessageType) {
        id = UUID().uuidString
        self.sender =  sender
        self.receiver = receiver
        self.createDate = Date()
        self.content = content
        self.status = status
        self.type = type
    }
    
    func isSendByMe() -> Bool {
        sender.username == RootViewModel.shared.currentUser.username
    }
}
