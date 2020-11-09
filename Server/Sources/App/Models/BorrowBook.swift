//
//  BorrowBook.swift
//  
//
//  Created by Phucnh on 10/19/20.
//

import Fluent
import Vapor

final class BorrowBook: Model {
    
    static let schema = "borrow_book"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "title")
    var userBookID: UserBook.IDValue
    
    @Field(key: "author")
    var borrowerID: User.IDValue
    
    @Field(key: "borrow_date")
    var borrowDate: Date
    
    @Field(key: "description")
    var borrowDays: Int
    
    @Field(key: "adress")
    var adress: String
    
    @Field(key: "message")
    var message: String
    
    // we auto get from userBook
    @OptionalField(key: "status_des")
    var statusDes: String?
    
    // state this object: waiting, accept, ...
    @Field(key: "state")
    var state: String
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?
    
    init() { }
}

extension BorrowBook: Content { }

struct GetBorrowBook: Content {
    
    var id: String?
    
    var userBookID: String?
    
    var borrowerID: String?
    
    var borrowDate:  Date?
    
    var borrowDays: Int?
    
    var adress: String?
    
    var message: String?
    
    var statusDes: String?
    
    var state: String?
    
    var createdAt: Date?
    
    var updatedAt: Date?
    
    init() { }
}
