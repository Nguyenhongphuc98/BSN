//
//  UpdateUBViewModel.swift
//  Interface
//
//  Created by Phucnh on 10/31/20.
//

import SwiftUI
import Business
import Combine

class UpdateUBViewModel: NetworkViewModel {
    
    var userbookManager: UserBookManager
    
    @Published var bState: BookState
    
    @Published var bStatus: BookStatus
    
    override init() {
        userbookManager = UserBookManager()
        bState = .available
        bStatus = .new
        super.init()
        
        observerUpdate()
    }
    
    func update(model: BUserBook) {
        isLoading = true
        let eub = EUserBook(id: model.id,
                            status: model.status!.rawValue,
                            state: model.state!.rawValue,
                            statusDes: model.statusDes
                            )
        userbookManager.updateUserBook(ub: eub)
    }
    
    private func observerUpdate() {
        /// Get save user_book
        userbookManager
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

