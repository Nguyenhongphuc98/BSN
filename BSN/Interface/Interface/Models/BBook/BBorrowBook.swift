//
//  BBorrowBook.swift
//  Interface
//
//  Created by Phucnh on 10/27/20.
//

import SwiftUI
import Business

class BBorrowBook: ObservableObject, Identifiable {
    
    var id: String?
    
    var userbook: BUserBook
    
    var transactionInfo: BTransactionInfo
    
    init() {
        id = UUID().uuidString
        userbook = BUserBook()
        transactionInfo = BTransactionInfo(
            exchangeDate: Date(),
            numDay: 0,
            adress: "KTX khu A, Đại học quốc gia",
            message: "Bạn ơi cho mình mượn với nhé",
            progess: .accept
        )
    }
    
    // using for load and submit new borrowbook
    init(userbook: EUserBook) {
        self.userbook = BUserBook(
            ubid: userbook.id,
            uid: userbook.userID,
            ownerName: userbook.ownerName,
            status: userbook.status,
            title: userbook.title!,
            author: userbook.author!,
            state: userbook.state,
            cover: userbook.cover,
            des: userbook.statusDes
        )
        
        transactionInfo = BTransactionInfo(
            exchangeDate: Date(),
            numDay: 0,
            adress: "",
            message: "",
            progess: .new
        )
    }
    
    init(ebb: EBorrowBook) {
        self.id = ebb.id
        self.userbook = BUserBook(
            ownerName: ebb.brorrowerName,
            status: ebb.bookStatus,
            title: ebb.bookTitle!,
            author: ebb.bookAuthor!,
            state: BookState.unknown.rawValue, // in this case we don't care this value
            cover: ebb.bookCover,
            des: ebb.message)
        
        transactionInfo = BTransactionInfo(
            exchangeDate: Date.getDate(dateStr: ebb.borrowDate),
            numDay: ebb.borrowDays,
            adress: ebb.adress!,
            message: ebb.message!,
            progess: ExchangeProgess(rawValue: ebb.state!)!
        )
    }
}
