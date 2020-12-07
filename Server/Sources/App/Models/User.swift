//
//  User.swift
//  
//
//  Created by Phucnh on 10/16/20.
//

import Fluent
import Vapor
import FluentPostgresDriver

final class User: Model {
    
    static let schema = "user"
    
    @ID(key: .id)
    var id: UUID?
    
    //@Field(key: "username")
    //var username: String
    
    @Field(key: "displayname")
    var displayname: String
    
    @OptionalField(key: "avatar")
    var avatar: String?
        
    @OptionalField(key: "cover")
    var cover: String?
    
    // Format: longitude, latitude -Name on map
    @OptionalField(key: "location")
    var location: String?
        
    @OptionalField(key: "about")
    var about: String?
        
    @Field(key: "account_id")
    var accountID: Account.IDValue
        
    @Timestamp(key: "create_at", on: .create)
    var createdAt: Date?
        
    init() { }
    
    init(id: UUID? = nil, username: String, displayname: String, avatar: String? = nil, cover: String? = nil, location: String? = nil, about: String? = nil, accountID: Account.IDValue) {
        self.id = id
        //self.username = username
        self.displayname = displayname
        self.avatar = avatar
        self.cover = cover
        self.location = location
        self.about = about
        self.accountID = accountID
    }
}

extension User: Content { }

extension User {
    struct Update: Content {
        var id: String?
        var displayname: String?
        var avatar: String?
        var cover: String?
        var location: String?
        var about: String?
    }
}
