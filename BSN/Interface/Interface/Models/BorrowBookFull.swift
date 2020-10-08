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
    
    var seen: Bool
    
    override init() {
        traddingAddress = "KTX khu A, DHQG - Khu pho 6, Linh Trung, Thu Duc."
        borrowDate = Date()
        numOfDay = 7
        message = "Cho mình mượn sách nhé!"
        seen = false
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
        super.init()
        self.book = book.book
        self.statusDes = book.statusDes
    }
}
