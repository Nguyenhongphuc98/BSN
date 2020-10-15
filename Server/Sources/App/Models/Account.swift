//
//  Account.swift
//
//
//  Created by Phucnh on 10/15/20.
//

import Fluent
import Vapor

final class Account: Model, Content {
    
    static let schema = "account"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "username")
    var username: String
    
    @Field(key: "password")
    var password: String
    
    @Field(key: "isOnboarded")
    var isOnboarded: Bool
    
    init() { }
    
    init(id: UUID? = nil, username: String, password: String) {
        self.id = id
        self.username = username
        self.password = password
        self.isOnboarded = false
    }
}
