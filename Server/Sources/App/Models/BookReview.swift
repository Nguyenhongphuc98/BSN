//
//  BookReview.swift
//  
//
//  Created by Phucnh on 10/19/20.
//

import Fluent
import Vapor

final class BookReview: Model {
    
    static let schema = "book_review"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "user_id")
    var userID: User.IDValue
    
    @Field(key: "book_id")
    var bookID: Book.IDValue
    
    @Field(key: "title")
    var title: String
    
    @Field(key: "description")
    var description: String
    
    @Field(key: "write_rating")
    var writeRating: Int
    
    @Field(key: "character_rating")
    var characterRating: Int
    
    @Field(key: "target_rating")
    var targetRating: Int
    
    @Field(key: "info_rating")
    var infoRating: Int
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    init() { }
}

extension BookReview: Content { }
