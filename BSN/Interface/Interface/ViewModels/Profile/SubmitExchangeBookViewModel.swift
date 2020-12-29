//
//  CreateExchangeBookViewModel.swift
//  Interface
//
//  Created by Phucnh on 10/11/20.
//

import SwiftUI
import Business
import Combine

class SubmitExchangeBookViewModel: NetworkViewModel {
    
    let exchangeBookManager: ExchangeBookManager
    
    override init() {
        exchangeBookManager = ExchangeBookManager.shared
        super.init()
        
        setupReceiveSaveEBInfo()
    }
    
    func saveExchangeBook(passthroughtObj: PassthroughtEB) {
        isLoading = true
        
        let eb = EExchangeBook(
            firstUserBookID: passthroughtObj.needChangeUB.id!,
            exchangeBookID: passthroughtObj.wantChangeBook!.id!,
            firstStatusDes: passthroughtObj.needChangeUB.statusDes,
            state: ExchangeProgess.new.rawValue
        )
        
        exchangeBookManager.saveExchangeBook(eb: eb)
    }
    
    private func setupReceiveSaveEBInfo() {
        /// Get save user_book
        exchangeBookManager
            .changePublisher
            .sink {[weak self] (eb) in
                
                guard let self = self else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.isLoading = false
                    
                    if eb.id == "undefine" {
                        self.resourceInfo = .savefailure
                    } else {
                        self.resourceInfo = .success
                        DispatchQueue.main.async {
                            ExploreBookViewModel.shared.loadExchangeBooks()
                        }
                    }                   
                    self.showAlert.toggle()
                }
            }
            .store(in: &cancellables)
    }
}
