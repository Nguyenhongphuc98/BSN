//
//  ExchangeBook.swift
//  
//
//  Created by Phucnh on 10/19/20.
//

import Fluent
import Vapor

final class ExchangeBook: Model {
    
    static let schema = "exchange_book"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "first_user_book_id")
    var firstUserBookID: UserBook.IDValue
    
    @Field(key: "second_user_book_id")
    var secondUserBookID: UserBook.IDValue
    
    @Field(key: "exchange_book_id")
    var exchangeBookID: Book.IDValue
    
    @Field(key: "adress")
    var adress: String
    
    @Field(key: "message")
    var message: String
    
    // we auto get from userBook
    @OptionalField(key: "first_status_des")
    var firstStatusDes: String?
    
    // we auto get from userBook
    @OptionalField(key: "second_status_des")
    var secondStatusDes: String?
    
    // state this object: waiting, accept, ...
    @Field(key: "state")
    var state: String
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?
    
    init() { }
}

extension ExchangeBook: Content { }
