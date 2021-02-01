//
//  BorrowBookViewModel.swift
//  Interface
//
//  Created by Phucnh on 10/8/20.
//

import SwiftUI
import Business

// In submit request borrow book
class BorrowBookViewModel: NetworkViewModel {
    
    @Published var model: BBorrowBook
    
    @Published var borrowDate: Date
    
    @Published var numOfDay: Int
    
    @Published var address: String
    
    @Published var message: String
    
    private var userbookManager: UserBookManager
    
    private var borrowbookManager: BorrowBookManager
    
    override init() {
        model = BBorrowBook()
        borrowDate = Date()
        numOfDay = 7
        userbookManager = UserBookManager()
        borrowbookManager = BorrowBookManager()
        address = ""
        message = ""
        
        super.init()
        observerCoreUserBook()
        observerSaveBorrowBook()
    }
    
    func prepareData(ubid: String) {
        isLoading = true
        userbookManager.getUserBook(ubid: ubid)
    }
    
    func saveBorrowBook() {
        isLoading = true
        let bb = EBorrowBook(
            userBookID: model.userbook.id,
            borrowerID: AppManager.shared.currenUID,
            borrowDate: borrowDate,
            borrowDays: numOfDay + 1,
            adress: address,
            message: message,
            statusDes: model.userbook.statusDes,
            state: ExchangeProgess.waiting.rawValue // when created, it will wating for accept
        )
        borrowbookManager.saveBorrowBook(borrowBook: bb)
    }
    
    private func observerCoreUserBook() {
        userbookManager
            .getUserBookPublisher
            .sink {[weak self] (ub) in
                
                guard let self = self else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.isLoading = false
                    
                    if ub.id == kUndefine {
                        //self.resourceInfo = .getfailure
                        //self.showAlert = true
                        // It shoud be load ok
                        // we just show alert when save failute :(
                    } else {
                        self.model = BBorrowBook(userbook: ub)
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    private func observerSaveBorrowBook() {
        borrowbookManager
            .changePublisher
            .sink {[weak self] (bb) in
                
                guard let self = self else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.isLoading = false
                    
                    self.resourceInfo = (bb.id == kUndefine) ?  .savefailure : .success
                    
                    self.showAlert = true
                }
            }
            .store(in: &cancellables)
    }
}
