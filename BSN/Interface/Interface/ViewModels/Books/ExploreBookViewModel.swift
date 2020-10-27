//
//  SearchViewViewModel.swift
//  Interface
//
//  Created by Phucnh on 10/5/20.
//

import SwiftUI
import Business

class ExploreBookViewModel: SearchBookViewModel {
    
    @Published var suggestBooks: [BSusggestBook]
    
    @Published var exchangeBooks: [ExchangeBook]
    
    override init() {
        suggestBooks = [BSusggestBook(), BSusggestBook(), BSusggestBook(), BSusggestBook()]
        exchangeBooks = [ExchangeBook(), ExchangeBook(), ExchangeBook(), ExchangeBook(), ExchangeBook(), ExchangeBook(), ExchangeBook(), ExchangeBook(), ExchangeBook()]
        super.init()
        startBusiness()
    }
}
