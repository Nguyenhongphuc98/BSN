//
//  ExchangeBookFull.swift
//  Interface
//
//  Created by Phucnh on 10/9/20.
//

import SwiftUI

class ExchangeBookFull: BorrowBookDetail {
    
    // Book to exchange with others
    var myBook: BorrowBookDetail
    
    var traddingAddress: String
    
    var message: String
    
    var seen: Bool
    
    var result: BorrowResult
    
    // Use in case book decline
    var reason: String
    
    override init() {
        traddingAddress = "KTX khu A, DHQG - Khu pho 6, Linh Trung, Thu Duc."
        message = "Cho mình mượn sách nhé!"
        seen = false
        result = BorrowResult.allCases.randomElement()!
        reason = "Mình đang đi du lịch nên không cho mượn được thời gian này"
        myBook = BorrowBookDetail()
        super.init()
    }
    
    init(book: BorrowBookDetail,
         traddingAddress: String = "KTX khu A, DHQG - Khu pho 6, Linh Trung, Thu Duc.",
         message: String = "Cho mình đổi sách nhé!"
    ) {
        
        self.traddingAddress = traddingAddress
        self.message = message
        self.seen = false
        self.result = BorrowResult.allCases.randomElement()!
        self.reason = "Mình đang đi du lịch nên không trao đổi được thời gian này"
        self.myBook = BorrowBookDetail()
        super.init()
        self.book = book.book
        self.statusDes = book.statusDes
    }
}
