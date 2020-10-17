//
//  CreateAccount.swift
//  
//
//  Created by Phucnh on 10/15/20.
//

import Fluent

struct CreateAccount: Migration {
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("account")
            .id()
            .field("username", .string, .required)
            .field("password", .string, .required)
            .field("is_onboarded", .bool, .required)
            .unique(on: "username")
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("account").delete()
    }
}
