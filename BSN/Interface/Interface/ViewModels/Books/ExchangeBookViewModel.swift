//
//  ExchangeBookViewModel.swift
//  Interface
//
//  Created by Phucnh on 10/9/20.
//

import SwiftUI

// Manager in exchange book view (detail - available or not)
class ExchangeBookViewModel: ObservableObject {
    
    var exchangeBook: ExchangeBookFull
    
    var canExchange: Bool
    
    @Published var message: String
    
    @Published var traddingAdress: String
    
    init() {
        exchangeBook = ExchangeBookFull()
        message = ""
        traddingAdress = ""
        canExchange = Int.random(in: 0..<2) == 1
    }
}
