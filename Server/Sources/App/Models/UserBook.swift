//
//  UserBook.swift
//  
//
//  Created by Phucnh on 10/19/20.
//

import Fluent
import Vapor

final class UserBook: Model {
    
    static let schema = "user_book"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "user_id")
    var userID: User.IDValue
    
    @Field(key: "book_id")
    var bookID: Book.IDValue
    
    @Field(key: "status")
    var status: String
    
    @Field(key: "state")
    var state: String
    
    @Field(key: "status_des")
    var statusDes: String
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    init() { }
}

extension UserBook: Content { }

extension UserBook {
    
    // Return model when user search book
    func toUserSerchBook(cover: String, title: String, author: String) -> SearchUserBook {
        SearchUserBook(
            cover: cover,
            title: title,
            author: author,
            status: self.status
        )
    }
}

// MARK: - SearchUserBook
struct SearchUserBook: Content {
    
    var cover: String
    
    var title: String
    
    var author: String
    
    var status: String
}
