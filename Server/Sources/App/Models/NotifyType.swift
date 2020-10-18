//
//  NotifyType.swift
//  
//
//  Created by Phucnh on 10/17/20.
//

import Fluent
import Vapor

final class NotifyType: Model {
    
    static let schema = "notify_type"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    init() { }
    
    init(id: UUID? = nil, name: String) {
        self.id = id
        self.name = name
    }
}

extension NotifyType: Content { }
