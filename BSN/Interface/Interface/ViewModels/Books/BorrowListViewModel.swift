//
//  BorrowListViewModel.swift
//  Interface
//
//  Created by Phucnh on 10/6/20.
//

import SwiftUI
import Business

class BorrowListViewModel: NetworkViewModel {
    
    @Published var models: [BAvailableTransaction]
    
    private var userbookManager: UserBookManager
    
    override init() {
        models = []
        userbookManager = UserBookManager()
        
        super.init()
        observerAvailableTransactionUserBook()
    }
    
    func prepareData(bid: String) {
        isLoading = true
        userbookManager.getAvailableUserBooks(bid: bid)
    }
    
    private func observerAvailableTransactionUserBook() {
        userbookManager
            .getUserBooksPublisher
            .sink {[weak self] (ubs) in
                
                guard let self = self else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.isLoading = false
                    
                    ubs.forEach { (ub) in
                        let a = BAvailableTransaction(userBook: ub)
                        self.models.appendUnique(item: a)
                    }
                }
            }
            .store(in: &cancellables)
    }
}
