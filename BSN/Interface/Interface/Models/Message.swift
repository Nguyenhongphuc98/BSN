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

// MARK: - Message model
class Message: ObservableObject, Identifiable {
    
    var id: String
    
    var sender: User
    
    var receiver: User
    
    var createDate: Date
    
    var content: String
    
    var status: MessageStatus
    
    init() {
        id = UUID().uuidString
        sender = User()
        receiver = RootViewModel.shared.currentUser
        createDate = randomDate()
        content = randomMessage()
        status = .received
    }
}
