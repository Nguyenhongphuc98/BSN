//
//  Account.swift
//
//
//  Created by Phucnh on 10/15/20.
//

import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        return "It works!"
    }

    app.get("hello") { req -> String in
        return "Hello, world!"
    }

    try app.register(collection: AccountController())
    try app.register(collection: UserController())
    
    try app.register(collection: NotifyTypeController())
    try app.register(collection: NotifyController())
    
    try app.register(collection: SettingController())
    
    try app.register(collection: MessageTypeController())
    try app.register(collection: ChatController())
}
