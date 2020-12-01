//
//  Chat.swift
//  Interface
//
//  Created by Phucnh on 11/13/20.
//

import Foundation

public class Chat: ObservableObject, AppendUniqueAble {
    
    public var id: String?
    var partnerID: String
    var partnerName: String
    
    @Published var partnerPhoto: String?
    @Published var seen: Bool
    
    var lastMessage: Message?

    init() {
        id = nil
        partnerID = kUndefine
        partnerName = kUndefine
        lastMessage = Message()
        seen = false
    }
    
    init(id: String? = nil, partnerID: String, partnerName: String, partnerPhoto: String? = nil, lastMessage: Message? = nil, seen: Bool) {
        self.id = id
        self.partnerID = partnerID
        self.partnerName = partnerName
        self.partnerPhoto = partnerPhoto
        self.lastMessage = lastMessage
        self.seen = seen
    }
    
    init(id: String? = nil, partner: User) {
        self.id = id
        self.partnerID = partner.id
        self.partnerName = partner.displayname
        self.partnerPhoto = partner.avatar
        self.seen = false
    }
}
