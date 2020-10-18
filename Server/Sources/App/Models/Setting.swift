//
//  Setting.swift
//  
//
//  Created by Phucnh on 10/18/20.
//

import Fluent
import Vapor

final class Setting: Model {
    
    static let schema = "setting"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "language")
    var language: String
    
    @Field(key: "theme")
    var theme: String
    
    @Field(key: "user_id")
    var userID: User.IDValue
    
    init() { }
    
    init(id: UUID? = nil, language: String, theme: String, user: User.IDValue) {
        self.id = id
        self.language = name
        self.theme = theme
        self.userID = user
    }
}

extension Setting: Content { }
