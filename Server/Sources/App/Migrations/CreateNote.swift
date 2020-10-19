//
//  CreateNote.swift
//  
//
//  Created by Phucnh on 10/19/20.
//

import Fluent

struct CreateNote: Migration {
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        let note = Note()
        
        return database.schema(Note.schema)
            .id()
            .field(note.$userBookID.key, .uuid, .references(UserBook.schema, "id"))
            .field(note.$content.key, .string)
            .field("created_at", .datetime)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(Note.schema).delete()
    }
}
