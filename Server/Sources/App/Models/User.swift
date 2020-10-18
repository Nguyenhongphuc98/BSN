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
    
    @Field(key: "avatar")
    var avatar: String
        
    @Field(key: "cover")
    var cover: String
    
    // Format: longitude, latitude -Name on map
    @Field(key: "location")
    var location: String
        
    @Field(key: "about")
    var about: String
        
    @Field(key: "account_id")
    var accountID: Account.IDValue
        
    @Timestamp(key: "create_at", on: .create)
    var createdAt: Date?
        
    init() { }
    
    init(id: UUID? = nil, username: String, displayname: String, avatar: String, cover: String, location: String, about: String, accountID: Account.IDValue) {
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
