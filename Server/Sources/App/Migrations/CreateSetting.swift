//
//  CreateSetting.swift
//  
//
//  Created by Phucnh on 10/18/20.
//

import Fluent

struct CreateSetting: Migration {
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        let setting = Setting()
        
        return database.schema(Setting.schema)
            .id()
            .field(setting.$language.key, .string, .required)
            .field(setting.$theme.key, .string, .required)
            .field(setting.$userID.key, .uuid, .references(User.schema, "id"))
            .unique(on: setting.$userID.key)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(Setting.schema).delete()
    }
}
