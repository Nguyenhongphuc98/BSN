//
//  HistoryViewModel.swift
//  Interface
//
//  Created by Phucnh on 12/17/20.
//

import SwiftUI
import Business

class HistoryViewModel: NetworkViewModel {
    
    var bbManager: BorrowBookManager
    
    @Published var borrowModels: [History]
    @Published var exchangeModels: [History]
    
    override init() {
        bbManager = .init()
        borrowModels = []
        exchangeModels = []
        
        super.init()
        observerHistoryData()
        fetchingHistory()
    }
    
    func fetchingHistory() {
        isLoading = true
        bbManager.getHistoryBorrowBook()
    }
    
    private func observerHistoryData() {
        bbManager
            .getBorrowBooksPublisher
            .sink {[weak self] (bbs) in

                guard let self = self else { return }

                DispatchQueue.main.async {

                    if !bbs.isEmpty {
                        if bbs[0].id != kUndefine {
                            bbs.forEach { (bb) in
                                let model = History(
                                    id: bb.id!,
                                    title: bb.bookTitle!,
                                    borrower: bb.brorrowerName!,
                                    owner: bb.ownerName!,
                                    requesterID: bb.borrowerID!,
                                    time: bb.updatedAt!,
                                    state: ExchangeProgess(rawValue: bb.state!) ?? .accept
                                )
                                self.borrowModels.appendUnique(item: model)
                            }
                        }
                    }
                    self.isLoading = false
                }
            }
            .store(in: &cancellables)
    }
}
