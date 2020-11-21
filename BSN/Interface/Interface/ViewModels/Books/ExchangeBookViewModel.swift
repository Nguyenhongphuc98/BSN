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
    
    @Published var exchangeBook: BExchangeBookFull
    
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
        observerEBInfo()
        observerSaveresult()
    }
    
    func prepareData(ebID: String) {
        isLoading = true
        exchangeBook.id = ebID
        ebManager.getComputeExchangeBook(ebid: ebID)
    }
    
    func requestExchangeBook() {
        // add second user book to available exchange
        isLoading = true
        let newEB = EExchangeBook(
            id: exchangeBook.id!,
            firstUserBookID: exchangeBook.needChangeBook.id!,
            secondUserBookID: exchangeBook.wantChangeBook?.id,
            adress: traddingAdress,
            message: message,
            secondStatusDes: exchangeBook.wantChangeBook?.statusDes,
            state: ExchangeProgess.waiting.rawValue
            )
        ebManager.updateExchangeBook(eb: newEB)
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
                                firstubid: eb.firstUserBookID,
                                secondubid: eb.secondUserBookID,
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
    
    private func observerSaveresult() {
        ebManager
            .changePublisher
            .sink {[weak self] (eb) in
                
                guard let self = self else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.resourceInfo = (eb.id == kUndefine) ? .savefailure : .success
                    self.isLoading = false
                    self.showAlert = true
                }
            }
            .store(in: &cancellables)
    }
}
