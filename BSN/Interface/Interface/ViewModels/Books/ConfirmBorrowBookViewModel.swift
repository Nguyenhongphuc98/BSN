//
//  ConfirmBorrowBookViewModel.swift
//  Interface
//
//  Created by Phucnh on 10/8/20.
//

import SwiftUI

class ConfirmBorrowBookViewModel {
    
    var borrowBook: BorrowBookFull
    
    init() {
        borrowBook = BorrowBookFull()
    }
    
    func didAccept(complete: @escaping (Bool) -> Void) {
        complete(true)
    }
    
    func didDecline(complete: @escaping (Bool) -> Void) {
        complete(true)
    }
}
