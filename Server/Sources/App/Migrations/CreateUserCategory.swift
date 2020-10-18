//
//  CreateUserCategory.swift
//  
//
//  Created by Phucnh on 10/18/20.
//

import Fluent

struct CreateUserCategory: Migration {
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        let userCategory = UserCategory()
        
        return database.schema(UserCategory.schema)
            .id()
            .field(userCategory.$userID.key, .uuid, .references(User.schema, "id"))
            .field(userCategory.$categoryID.key, .uuid, .references(Category.schema, "id"))
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(UserCategory.schema).delete()
    }
}
