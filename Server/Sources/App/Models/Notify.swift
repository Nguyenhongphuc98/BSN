//
//  Notify.swift
//  
//
//  Created by Phucnh on 10/18/20.
//

import Fluent
import Vapor

final class Notify: Model {
    
    static let schema = "notify"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "notify_type_id")
    var notifyTypeID: NotifyType.IDValue
    
    @Field(key: "actor_id")
    var actorID: User.IDValue
    
    @Field(key: "receiver_id")
    var receiverID:  User.IDValue
    
    @Field(key: "destination_id")
    var destionationID: UUID
    
    @Field(key: "seen")
    var seen: Bool
    
    // By default title, content auto gen, but in case admin send
    // We will need content and title
    @Field(key: "title")
    var title: String?
    
    @Field(key: "content")
    var content: String?
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    init() { }
    
    init(typeID: NotifyType.IDValue, actor: User.IDValue, receiver: User.IDValue, des: UUID, title: String? = nil, content: String? = nil) {
        self.notifyTypeID = typeID
        self.actorID = actor
        self.receiverID = receiver
        self.destionationID = des
        self.title = title
        self.content = content
    }
}

extension Notify: Content { }

extension Notify {
    
    struct GetFull: Content {
        var id: String
        var notifyTypeID: String
        var actorID: String
        var receiverID: String
        var destionationID: String
        var seen: Bool
        var createdAt: Date?
        
        var actorName: String
        var actorPhoto: String?
        var notifyName: String
        
        var title: String?
        var content: String?
    }
    
    struct Update: Content {
        var id: String
        var seen: Bool
    }
    
    struct CreateForAll: Content {
        var title: String
        var content: String
    }
}
