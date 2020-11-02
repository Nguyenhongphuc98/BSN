//
//  ExchangeBook.swift
//  
//
//  Created by Phucnh on 10/19/20.
//

import Fluent
import Vapor

//final class ExchangeBook: Model {
//
//    static let schema = "exchange_book"
//
//    @ID(key: .id)
//    var id: UUID?
//
//    @Field(key: "first_user_book_id")
//    var firstUserBookID: UserBook.IDValue
//
//    @OptionalField(key: "second_user_book_id")
//    var secondUserBookID: UserBook.IDValue?
//
//    @Field(key: "exchange_book_id")
//    var exchangeBookID: Book.IDValue
//
//    @OptionalField(key: "adress")
//    var adress: String?
//
//    @OptionalField(key: "message")
//    var message: String?
//
//    // we auto get from userBook
//    @OptionalField(key: "first_status_des")
//    var firstStatusDes: String?
//
//    // we auto get from userBook
//    @OptionalField(key: "second_status_des")
//    var secondStatusDes: String?
//
//    // state this object: waiting, accept, ...
//    @Field(key: "state")
//    var state: String
//
//    @Timestamp(key: "created_at", on: .create)
//    var createdAt: Date?
//
//    @Timestamp(key: "updated_at", on: .update)
//    var updatedAt: Date?
//
//    init() { }
//}

final class ExchangeBook: Model, Content {
    
    static let schema = "exchange_book"
    
    @ID(key: .id)
    var id: UUID?
    
    @OptionalField(key: "first_user_book_id")
    var firstUserBookID: UserBook.IDValue?
    
    @OptionalField(key: "second_user_book_id")
    var secondUserBookID: UserBook.IDValue?
    
    @OptionalField(key: "exchange_book_id")
    var exchangeBookID: Book.IDValue?
    
    @OptionalField(key: "adress")
    var adress: String?
    
    @OptionalField(key: "message")
    var message: String?
    
    // we auto get from userBook
    @OptionalField(key: "first_status_des")
    var firstStatusDes: String?
    
    // we auto get from userBook
    @OptionalField(key: "second_status_des")
    var secondStatusDes: String?
    
    // state this object: waiting, accept, ...
    @OptionalField(key: "state")
    var state: String?
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?
    
    init() { }
}

struct GetExchangeBook: Content {
    
    var id: String?
    
    /// Apear in newest exchange book
    var firstTitle: String?
    
    var firstAuthor: String?
    
    var firstCover: String?
    
    var location: String?
    
    var secondTitle: String?
    
    var secondAuthor: String?
    
    /// Should fill when view detail
    var firstOwnerName: String?
    
    var secondStatus: String?
    
    var state: String?
    
    init(id: String? = nil, firstTitle: String, firstAuthor: String, firstCover: String? = nil, location: String? = nil, secondTitle: String? = nil, secondAuthor: String? = nil, firstOwnerName: String? = nil, secondStatus: String? = nil, state: String? = nil) {
        
        self.id = id
        self.firstTitle = firstTitle
        self.firstAuthor = firstAuthor
        self.firstCover = firstCover
        self.location = location
        self.secondTitle = secondTitle
        self.secondAuthor = secondAuthor
        self.firstOwnerName = firstOwnerName
        self.secondStatus = secondStatus
        self.state = state
    }
}
