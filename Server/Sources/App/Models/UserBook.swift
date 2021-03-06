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
    
    init(id: String? = nil, uid: UUID, bid: UUID, status: String, state: String, statusDes: String) {
        self.id = UUID(uuidString: id ?? "")
        self.userID = uid
        self.bookID = bid
        self.status = status
        self.state = state
        self.statusDes = statusDes
    }
}

extension UserBook: Content { }

extension UserBook {
    
    // Return model when user search book
    func toUserSerchBook(cover: String? = nil, title: String, author: String) -> GetUserBook {
        GetUserBook(
            id: self.id!.uuidString,
            userID: self.userID.uuidString,
            bookID: self.bookID.uuidString,
            cover: cover,
            title: title,
            author: author,
            status: self.status,
            state: self.state
        )
    }
}

// MARK: - Updte user book

struct UpdateUserbook: Content {
    
    // Can't inheritance so don't neecd to using class
    
    var status: String?
    
    var state: String?
    
    var statusDes: String?
}

// MARK: - SearchUserBook
struct GetUserBook: Content {
    
    var id: String?
    
    var userID: String?
    
    var bookID: String?
    
    var cover: String?
    
    var title: String?
    
    var author: String?
    
    var status: String?
    
    var state: String?
    
    var description: String?
    
    var statusDes: String?
    
    var ownerName: String?
    
    var ownerAvatar: String?
    
    var location: String? // location of user owner this book
}
