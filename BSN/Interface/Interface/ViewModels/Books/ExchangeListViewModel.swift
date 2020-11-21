//
//  ExchangeListViewModel.swift
//  Interface
//
//  Created by Phucnh on 10/9/20.
//

import SwiftUI
import Business

// Manage list show in list exchange books list (seperate view)
class ExchangeListViewModel: NetworkViewModel {
    
    @Published var models: [BAvailableExchange]
    
    private var ebManager: ExchangeBookManager
    
    override init() {
        models = []
        ebManager = ExchangeBookManager()
        
        super.init()
        setupReceiveEBs()
    }
    
    func prepareData(bid: String) {
        isLoading = true
        ebManager.getAvailableExchangeBooks(bid: bid)
    }
    
    private func setupReceiveEBs() {
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
                            let model = BAvailableExchange(eb: eb)
                            self.models.appendUnique(item: model)
                        }
                    }
                }
            }
            .store(in: &cancellables)
    }
}
