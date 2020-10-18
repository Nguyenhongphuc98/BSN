//
//  MessageType.swift
//  
//
//  Created by Phucnh on 10/18/20.
//

import Fluent
import Vapor

final class MessageType: Model {
    
    static let schema = "message_type"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    init() { }
}

extension MessageType: Content { }
