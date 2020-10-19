//
//  Note.swift
//  
//
//  Created by Phucnh on 10/19/20.
//

import Fluent
import Vapor

final class Note: Model {
    
    static let schema = "note"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "user_book_id")
    var userBookID: UserBook.IDValue
    
    @Field(key: "content")
    var content: String
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    init() { }
}

extension Note: Content { }