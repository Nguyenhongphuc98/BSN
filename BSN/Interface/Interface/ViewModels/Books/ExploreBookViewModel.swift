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
    
    private var ebManager: ExchangeBookManager
    
    override init() {
        suggestBooks = [BSusggestBook(), BSusggestBook(), BSusggestBook(), BSusggestBook()]
        exchangeBooks = []
        ebManager = ExchangeBookManager()
        super.init()
        
        setupReceiveEBs()
    }
    
    func prepareData() {
        // load favorite book
        // load page 0 exchange book
        loadExchangeBooks(page: 0)
    }
    
    func loadExchangeBooks(page: Int) {
        ebManager.getExchangeBooks(page: page)
    }
    
    private func setupReceiveEBs() {
        /// Get save user_book
        ebManager
            .getExchangeBooksPublisher
            .sink {[weak self] (ebs) in
                
                guard let self = self else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.isLoading = false
                    
                    if !ebs.isEmpty {
                        ebs.forEach { (eb) in
                            let model = BExchangeBook(
                                firstTitle: eb.firstTitle!,
                                firstAuthor: eb.firstAuthor!,
                                firstCover: eb.firstCover!,
                                partnerLocation: eb.location!,
                                sencondTitle: eb.secondTitle!,
                                secondAuthor: eb.secondAuthor!
                            )
                            self.exchangeBooks.append(model)
                        }
                    }
                }
            }
            .store(in: &cancellables)
    }
}
