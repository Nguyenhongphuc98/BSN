//
//  CreateCategory.swift
//  
//
//  Created by Phucnh on 10/18/20.
//

import Fluent

struct CreateCategory: Migration {
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        let category = Category()
        
        return database.schema(Category.schema)
            .id()
            .field(category.$name.key, .string, .required)
            .unique(on: category.$name.key)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(Category.schema).delete()
    }
}
