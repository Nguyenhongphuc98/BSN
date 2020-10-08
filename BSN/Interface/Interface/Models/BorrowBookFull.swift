//
//  BorrowBookFull.swift
//  Interface
//
//  Created by Phucnh on 10/8/20.
//

import SwiftUI

enum BorrowResult: CaseIterable {
    case success
    case fail
}

class BorrowBookFull: BorrowBookDetail {
    
    var traddingAddress: String
    
    var borrowDate: Date
    
    var numOfDay: Int
    
    var message: String
    
    var seen: Bool
    
    var result: BorrowResult
    
    // Use in case book decline
    var reason: String
    
    override init() {
        traddingAddress = "KTX khu A, DHQG - Khu pho 6, Linh Trung, Thu Duc."
        borrowDate = Date()
        numOfDay = 7
        message = "Cho mình mượn sách nhé!"
        seen = false
        result = BorrowResult.allCases.randomElement()!
        reason = "Mình đang đi du lịch nên không cho mượn được thời gian này"
        super.init()
    }
    
    init(book: BorrowBookDetail,
         traddingAddress: String = "KTX khu A, DHQG - Khu pho 6, Linh Trung, Thu Duc.",
         borrowDate: Date = Date(),
         numOfday: Int = 7,
         message: String = "Cho mình mượn sách nhé!"
    ) {
        
        self.traddingAddress = traddingAddress
        self.borrowDate = borrowDate
        self.numOfDay = numOfday
        self.message = message
        self.seen = false
        self.result = BorrowResult.allCases.randomElement()!
        self.reason = "Mình đang đi du lịch nên không cho mượn được thời gian này"
        super.init()
        self.book = book.book
        self.statusDes = book.statusDes
    }
}
