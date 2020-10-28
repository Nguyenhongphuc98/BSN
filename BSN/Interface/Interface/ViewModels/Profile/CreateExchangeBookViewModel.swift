//
//  CreateExchangeBookViewModel.swift
//  Interface
//
//  Created by Phucnh on 10/11/20.
//

import SwiftUI

class CreateExchangeBookViewModel: ObservableObject {
    
    var exchangeBook: BExchangeBook
    
    init() {
        exchangeBook = BExchangeBook()
    }
    
    func addExchangeBook(complete: @escaping (Bool) -> Void) {
        complete(true)
    }
}
