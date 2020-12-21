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
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            ExploreBookViewModel.shared.loadExchangeBooks(page: 0)
        }
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
                    
                    self.resourceInfo = (eb.id == "undefine") ? .savefailure : .success
                    self.showAlert.toggle()
                }
            }
            .store(in: &cancellables)
    }
}
