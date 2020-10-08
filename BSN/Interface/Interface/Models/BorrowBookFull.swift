//
//  BorrowBookFull.swift
//  Interface
//
//  Created by Phucnh on 10/8/20.
//

import SwiftUI

class BorrowBookFull: BorrowBookDetail {
    
    var traddingAddress: String
    
    var borrowDate: Date
    
    var numOfDay: Int
    
    var message: String
    
    override init() {
        traddingAddress = ""
        borrowDate = Date()
        numOfDay = 7
        message = ""
        super.init()
    }
    
    init(book: BorrowBookDetail, traddingAddress: String = "", borrowDate: Date = Date(), numOfday: Int = 7, message: String = "Cho mình mượn sách nhé!") {
        self.traddingAddress = traddingAddress
        self.borrowDate = borrowDate
        self.numOfDay = numOfday
        self.message = message
        super.init()
        self.book = book.book
        self.statusDes = book.statusDes
    }
}
