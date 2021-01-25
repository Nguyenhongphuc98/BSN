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
    
    @Field(key: "userbook_id")
    var userBookID: UserBook.IDValue
    
    @Field(key: "borrower_id")
    var borrowerID: User.IDValue
    
    @Field(key: "borrow_date")
    var borrowDate: Date
    
    @Field(key: "borrow_days")
    var borrowDays: Int
    
    @Field(key: "adress")
    var adress: String
    
    // In case state is new/accept, it hold message borrower to owner\\
    // other case (decline), it hold reason decline\\
    
    // This is message send to owner
    @Field(key: "message")
    var message: String
    
    // Message when user accept or decline
    @Field(key: "response_message")
    var responseMessage: String?
    
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

extension BorrowBook {
    
    struct GetFull: Content {
        
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
        
        var bookCover: String?
        var bookTitle: String?
        var bookAuthor: String?
        var bookStatus: String?
        var brorrowerName: String?
        var ownerName: String?
        
        var responseMessage: String?
    }
}
