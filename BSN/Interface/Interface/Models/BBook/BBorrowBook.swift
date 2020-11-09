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
    
    var book: BUserBook
    
    var transactionInfo: BTransactionInfo
    
    init() {
        id = UUID().uuidString
        book = BUserBook()
        transactionInfo = BTransactionInfo(
            exchangeDate: Date(),
            numDay: 0,
            adress: "KTX khu A, Đại học quốc gia",
            message: "Bạn ơi cho mình mượn với nhé",
            progess: .accept
        )
    }
    
    init(userbook: EUserBook) {
        book = BUserBook(
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
}
