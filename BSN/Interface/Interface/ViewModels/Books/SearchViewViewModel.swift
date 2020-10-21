//
//  SearchViewViewModel.swift
//  Interface
//
//  Created by Phucnh on 10/5/20.
//

import SwiftUI
import Business

class SearchViewViewModel: SearchBookViewModel {
    
    @Published var books: [Book]
    
    @Published var exchangeBooks: [ExchangeBook]
    
    override init() {
        books = fakebooks
        exchangeBooks = [ExchangeBook(), ExchangeBook(), ExchangeBook(), ExchangeBook(), ExchangeBook(), ExchangeBook(), ExchangeBook(), ExchangeBook(), ExchangeBook()]
        super.init()
        startBusiness()
    }
}
