//
//  Device.swift
//  
//
//  Created by Phucnh on 12/4/20.
//

import Fluent
import Vapor

enum System: String, Codable {
    case iOS
    case android
}

final class Device: Model, Content {
    static let schema = "devices"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "system")
    var system: System
    
    @Field(key: "os_version")
    var osVersion: String
    
    @Field(key: "push_token")
    var pushToken: String?
    
    @Field(key: "user_id")
    var userID: User.IDValue
    
    init() {}
    
    init(id: UUID? = nil, system: System, osVersion: String, pushToken: String?, userID: User.IDValue ) {
        self.id = id
        self.system = system
        self.osVersion = osVersion
        self.pushToken = pushToken
        self.userID = userID
    }
}

