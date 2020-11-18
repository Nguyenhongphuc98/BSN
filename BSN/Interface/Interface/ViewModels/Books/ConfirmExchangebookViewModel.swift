//
//  ConfirmExchangebookViewModel.swift
//  Interface
//
//  Created by Phucnh on 11/18/20.
//

import SwiftUI
import Business

// Confirm (accept/ decline) or show result
class ConfirmExchangebookViewModel: NetworkViewModel {
    
    @Published var exchangeBook: BExchangeBookFull
    
    private var ebManager: ExchangeBookManager
    
    override init() {
        exchangeBook = BExchangeBookFull()
        ebManager = ExchangeBookManager()
        
        super.init()
        observerEBInfo()
    }
    
    func prepareData(ebID: String) {
        isLoading = true
        exchangeBook.id = ebID
        ebManager.getDetailExchangeBook(ebid: ebID)
    }
    
    private func observerEBInfo() {
        /// Get exchange book info (full)
        ebManager
            .getExchangeBookPublisher
            .sink {[weak self] (eb) in
                
                guard let self = self else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.isLoading = false
                    
                    if eb.id == kUndefine {
                        self.resourceInfo = .getfailure
                        self.showAlert = true
                    } else {
                        
                        withAnimation {
                            self.exchangeBook = BExchangeBookFull(
                                id: eb.id!,
                                state: eb.state!,
                                firstTitle: eb.firstTitle!,
                                firstAuthor: eb.firstAuthor!,
                                firstCover: eb.firstCover,
                                firstOwner: eb.firstOwnerName!,
                                firstStatusDes: eb.firstStatusDes!,
                                secondOwner: eb.secondOwnerName!,
                                secondStatusDes: eb.secondStatusDes!,
                                sencondTitle: eb.secondTitle!,
                                secondAuthor: eb.secondAuthor!,
                                secondCover: eb.secondCover,
                                adress: eb.adress!,
                                message: eb.message!
                            )
                            // Mark != nil to allow show this book in confirm view
                            self.exchangeBook.wantChangeBook?.id = "undefine"
                        }
                    }
                }
            }
            .store(in: &cancellables)
    }
}
