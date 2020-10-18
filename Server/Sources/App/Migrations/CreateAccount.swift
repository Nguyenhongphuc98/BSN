//
//  CreateAccount.swift
//  
//
//  Created by Phucnh on 10/15/20.
//

import Fluent

struct CreateAccount: Migration {
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        let account = Account()
        
        return database.schema(Account.schema)
            .id()
            .field(account.$username.key, .string, .required)
            .field(account.$password.key, .string, .required)
            .field(account.$isOnboarded.key, .bool, .required)
            .unique(on: account.$username.key)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(Account.schema).delete()
    }
}
