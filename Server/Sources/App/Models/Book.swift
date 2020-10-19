//
//  Book.swift
//  
//
//  Created by Phucnh on 10/19/20.
//

import Fluent
import Vapor

final class Book: Model {
    
    static let schema = "book"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "title")
    var title: String
    
    @Field(key: "author")
    var author: String
    
    @OptionalField(key: "cover")
    var cover:  String?
    
    @OptionalField(key: "description")
    var description: String?
    
    @Field(key: "category_id")
    var categoryID: Category.IDValue
    
    @Field(key: "isbn")
    var isbn: String
    
    @OptionalField(key: "avg_rating")
    var avgRating: Float?
    
    @OptionalField(key: "write_rating")
    var writeRating: Float?
    
    @OptionalField(key: "character_rating")
    var characterRating: Float?
    
    @OptionalField(key: "target_rating")
    var targetRating: Float?
    
    @OptionalField(key: "info_rating")
    var infoRating: Float?
    
    @OptionalField(key: "confirmed")
    var confirmed: Bool?
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    init() { }
}

extension Book: Content { }
