//
//  ConfirmBorrowBookViewModel.swift
//  Interface
//
//  Created by Phucnh on 10/8/20.
//

import SwiftUI
import Business

class ConfirmBorrowBookViewModel: NetworkViewModel {
    
    @Published var borrowBook: BBorrowBook
    
    private var bbManager: BorrowBookManager
    
    override init() {
        borrowBook = BBorrowBook()
        bbManager = BorrowBookManager()
        
        super.init()
        observerBorrowBookInfo()
    }
    
    func prepareData(bbid: String) {
        isLoading = true
        bbManager.getBorrowBook(bbid: bbid)
    }
    
    func didAccept(complete: @escaping (Bool) -> Void) {
        complete(true)
    }
    
    func didDecline(complete: @escaping (Bool) -> Void) {
        complete(true)
    }
    
    private func observerBorrowBookInfo() {
        bbManager
            .getBorrowBookPublisher
            .sink {[weak self] (bb) in
                
                guard let self = self else {
                    return
                }
                
                DispatchQueue.main.async { [weak self] in
                    self?.isLoading = false
                    self?.borrowBook = BBorrowBook(ebb: bb)
                    self?.objectWillChange.send()
                }
            }
            .store(in: &cancellables)
    }
}
