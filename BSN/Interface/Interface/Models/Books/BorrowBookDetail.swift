//
//  BorrowBookDetail.swift
//  Interface
//
//  Created by Phucnh on 10/6/20.
//

import SwiftUI

class BorrowBookDetail: BorrowBook {
    
    var book: Book
    
    var statusDes: String
    
    override init() {
        book = Book()
        statusDes = "Y như mới, không hề cấn góc, rất đẹp nhé"
    }
}
