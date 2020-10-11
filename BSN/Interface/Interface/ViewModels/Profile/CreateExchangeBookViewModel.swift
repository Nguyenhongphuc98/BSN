//
//  CreateExchangeBookViewModel.swift
//  Interface
//
//  Created by Phucnh on 10/11/20.
//

import SwiftUI

class CreateExchangeBookViewModel: ObservableObject {
    
    var exchangeBook: ExchangeBookFull
    
    init() {
        exchangeBook = ExchangeBookFull()
    }
    
    func addExchangeBook(complete: @escaping (Bool) -> Void) {
        complete(true)
    }
}
