//
//  ExchangeBookViewModel.swift
//  Interface
//
//  Created by Phucnh on 10/9/20.
//

import SwiftUI
import Business

// Manager in submit exchange book view (detail - available or not)
class ExchangeBookViewModel: NetworkViewModel {
    
    var exchangeBook: BExchangeBookFull
    
    @Published var canExchange: Bool
    
    @Published var message: String
    
    @Published var traddingAdress: String
    
    private var ebManager: ExchangeBookManager
    
    override init() {
        exchangeBook = BExchangeBookFull()
        message = ""
        traddingAdress = ""
        //canExchange = Int.random(in: 0..<2) == 1
        canExchange = false
        ebManager = ExchangeBookManager()
        
        super.init()
        setupReceiveEB()
    }
    
    func prepareData(ebID: String) {
        isLoading = true
        exchangeBook.id = ebID
        ebManager.getExchangeBook(ebid: ebID)
    }
    
    private func setupReceiveEB() {
        /// Get save user_book
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
                                firstubid: eb.firstubid,
                                secondubid: eb.secondubid,
                                firstTitle: eb.firstTitle!,
                                firstAuthor: eb.firstAuthor!,
                                firstCover: eb.firstCover,
                                firstOwner: eb.firstOwnerName!,
                                firstStatusDes: eb.firstStatusDes!,
                                firstStatus: eb.firstStatus!,
                                secondStatusDes: eb.secondStatusDes,
                                secondStatus: eb.secondStatus,
                                sencondTitle: eb.secondTitle!,
                                secondAuthor: eb.secondAuthor!,
                                secondCover: eb.secondCover
                            )
                            
                            self.canExchange = self.exchangeBook.wantChangeBook?.id != nil
                        }
                    }
                }
            }
            .store(in: &cancellables)
    }
}
