//
//  Chat.swift
//  Interface
//
//  Created by Phucnh on 11/13/20.
//

import Foundation

class Chat: ObservableObject, Identifiable {
    
    var id: String?
    
    var partnerID: String
    
    var partnerName: String
    
    var partnerPhoto: String?
    
    var lastMessage: Message?
    
    init() {
        id = kUndefine
        partnerID = kUndefine
        partnerName = kUndefine
        lastMessage = Message()
    }
    
    init(id: String? = nil, partnerID: String, partnerName: String, partnerPhoto: String? = nil, lastMessage: Message? = nil) {
        self.id = id
        self.partnerID = partnerID
        self.partnerName = partnerName
        self.partnerPhoto = partnerPhoto
        self.lastMessage = lastMessage
    }
    
    init(id: String? = nil, partner: User) {
        self.id = id
        self.partnerID = partner.id
        self.partnerName = partner.displayname
        self.partnerPhoto = partner.avatar
    }
}
