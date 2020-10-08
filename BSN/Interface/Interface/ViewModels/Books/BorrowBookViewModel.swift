//
//  BorrowBookViewModel.swift
//  Interface
//
//  Created by Phucnh on 10/8/20.
//

import SwiftUI

// In submit request borrow book
class BorrowBookViewModel: ObservableObject {
    
    var model: BorrowBookDetail
    
    @Published var traddingAddress: String
    
    @Published var borrowDate: Date
    
    @Published var numOfDay: Int
    
    @Published var message: String
    
    init() {
        model = BorrowBookDetail()
        traddingAddress = ""
        borrowDate = Date()
        numOfDay = 7
        message = ""
    }
    
    func didRequestBorrowBook(complete: @escaping (Bool) -> Void) {
        
        let newBorrowbook = BorrowBookFull(book: model, traddingAddress: traddingAddress, borrowDate: borrowDate, numOfday: numOfDay, message: message)
     
        // To- Do
        // Call BL
        complete(true)
    }
}
