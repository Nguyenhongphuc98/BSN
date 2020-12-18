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
    var ebManager: ExchangeBookManager
    
    @Published var borrowModels: [History]
    @Published var exchangeModels: [History]
    
    override init() {
        bbManager = .init()
        ebManager = .init()
        borrowModels = []
        exchangeModels = []
        
        super.init()
        observerHistoryData()
        fetchingHistory()
    }
    
    func fetchingHistory() {
        isLoading = true
        bbManager.getHistoryBorrowBook()
        ebManager.getHistoryExchangeBook()
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
                                    type: .borrow,
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
        
        ebManager
            .getExchangeBooksPublisher
            .sink {[weak self] (ebs) in

                guard let self = self else { return }

                DispatchQueue.main.async {

                    if !ebs.isEmpty {
                        if ebs[0].id != kUndefine {
                            ebs.forEach { (eb) in
                                let model = History(
                                    type: .exchange,
                                    id: eb.id!,
                                    title: eb.firstTitle!,
                                    borrower: eb.secondOwnerName ?? "Chưa có",
                                    owner: eb.firstOwnerName!,
                                    requesterID: eb.secondUserID ?? "",
                                    time: eb.updatedAt!,
                                    state: ExchangeProgess(rawValue: eb.state!) ?? .accept
                                )
                                self.exchangeModels.appendUnique(item: model)
                            }
                        }
                    }
                    self.isLoading = false
                }
            }
            .store(in: &cancellables)
    }
}
