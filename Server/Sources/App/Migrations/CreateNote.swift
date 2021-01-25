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
            .field(note.$pageRef.key, .string)
            .field(note.$photo.key, .string)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(Note.schema).delete()
    }
}

//struct AddFieldsNote: Migration {
//    
//    func prepare(on database: Database) -> EventLoopFuture<Void> {
//        let note = Note()
//        
//        return database.schema(Note.schema)
//            .field(note.$pageRef.key, .string)
//            .field(note.$photo.key, .string)            
//            .update()
//    }
//    
//    func revert(on database: Database) -> EventLoopFuture<Void> {
//        return database.schema(Note.schema).delete()
//    }
//}
