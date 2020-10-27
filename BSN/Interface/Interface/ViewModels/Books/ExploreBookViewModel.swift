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
    
    @Published var exchangeBooks: [BExchangeBook]
    
    override init() {
        suggestBooks = [BSusggestBook(), BSusggestBook(), BSusggestBook(), BSusggestBook()]
        exchangeBooks = [BExchangeBook(), BExchangeBook(), BExchangeBook(), BExchangeBook(), BExchangeBook()]
        super.init()
        startBusiness()
    }
}
