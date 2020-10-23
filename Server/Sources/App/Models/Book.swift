//
//  Book.swift
//  
//
//  Created by Phucnh on 10/19/20.
//

import Fluent
import Vapor

// MARK: - Base model
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
    
//    @Parent(key: "category_id")
//    var category: Category
    
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

// MARK: - Extension
extension Book: Content { }

extension Book {
    
    public func toSearchBook() -> SearchBook {
        SearchBook(
            id: self.id,
            title: self.title,
            author: self.author,
            cover: self.cover
        )
    }
    
    public func toBookDetail(numRead: Int, numAvailable: Int) -> BookDetail {
        BookDetail(
            id: self.id,
            book: self,
            numReading: numRead,
            numAvailable: numAvailable
        )
    }
}


// MARK: - Custom model
struct SearchBook: Content {
    
    var id: Book.IDValue?
    
    var title: String
    
    var author: String
    
    var cover: String?
}


struct BookDetail: Content {
    
    var id: Book.IDValue?
    
    var book: Book
    
    var numReading: Int
    
    var numAvailable: Int
}
