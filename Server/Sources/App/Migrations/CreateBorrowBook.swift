//
//  CreateBorrowBook.swift
//  
//
//  Created by Phucnh on 10/19/20.
//

import Fluent

struct CreateBorrowBook: Migration {
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        let borrowBook = BorrowBook()
        
        return database.schema(BorrowBook.schema)
            .id()
            .field(borrowBook.$userBookID.key, .uuid, .references(UserBook.schema, "id"))
            .field(borrowBook.$borrowerID.key, .uuid, .references(User.schema, "id"))
            .field(borrowBook.$borrowDate.key, .date)
            .field(borrowBook.$borrowDays.key, .int)
            .field(borrowBook.$adress.key, .string)
            .field(borrowBook.$message.key, .string)
            .field(borrowBook.$state.key, .string)
            .field(borrowBook.$statusDes.key, .string)
            .field("created_at", .datetime)
            .field("updated_at", .datetime)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(BorrowBook.schema).delete()
    }
}
