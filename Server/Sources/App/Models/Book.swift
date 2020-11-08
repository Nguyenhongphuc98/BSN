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
    
    // add in second step
    @OptionalField(key: "num_review")
    var numReview: Int?
    
    init() { }
}

// MARK: - Extension
extension Book: Content { }

//extension Book {
//    
//    public func toSearchBook() -> SearchBook {
//        SearchBook(
//            id: self.id,
//            title: self.title,
//            author: self.author,
//            cover: self.cover
//        )
//    }
//    
//    public func toBookDetail(numRead: Int, numAvailable: Int) -> BookDetail {
//        BookDetail(
//            id: self.id,
//            book: self,
//            numReading: numRead,
//            numAvailable: numAvailable
//        )
//    }
//}


// MARK: - Custom model
//struct SearchBook: Content {
//
//    var id: Book.IDValue?
//
//    var title: String
//
//    var author: String
//
//    var cover: String?
//}


struct GetBook: Content {
    
    // Any request should have this properties
    var id: String?
    
    var title: String
    
    var author: String
    
    var cover:  String?
    
    //====================
    
    var description: String?
    
    var categoryID: String?
    
    var isbn: String?
    
    var avgRating: Float?
    
    var writeRating: Float?
    
    var characterRating: Float?
    
    var targetRating: Float?
    
    var infoRating: Float?
    
    var confirmed: Bool?
    
    var createdAt: Date?
    
    var numReview: Int?
    
    // Addition
    var numReading: Int?
    
    var numAvailable: Int?
}
