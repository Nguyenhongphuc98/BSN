//
//  BorrowBookViewModel.swift
//  Interface
//
//  Created by Phucnh on 10/8/20.
//

import SwiftUI

// In submit request borrow book
class BorrowBookViewModel: ObservableObject {
    
    var model: BBorrowBook
    
    @Published var borrowDate: Date
    
    @Published var numOfDay: Int
    
    @Published var address: String
    
    @Published var message: String
    
    init() {
        model = BBorrowBook()
        borrowDate = Date()
        numOfDay = 7
        address = model.transactionInfo.adress
        message = model.transactionInfo.message
    }
    
    func didRequestBorrowBook(complete: @escaping (Bool) -> Void) {
     
        // To- Do
        // Call BL
        complete(true)
    }
}
