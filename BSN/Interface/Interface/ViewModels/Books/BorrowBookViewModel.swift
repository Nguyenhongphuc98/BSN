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
    
    override init() {
        model = BBorrowBook()
        borrowDate = Date()
        numOfDay = 7
        userbookManager = UserBookManager()
        address = ""
        message = ""
        
        super.init()
        observerCoreUserBook()
    }
    
    func prepareData(ubid: String) {
        isLoading = true
        userbookManager.getUserBook(ubid: ubid)
    }
    
    func didRequestBorrowBook(complete: @escaping (Bool) -> Void) {
     
        // To- Do
        // Call BL
        complete(true)
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
//                        self.resourceInfo = .getfailure
//                        self.showAlert = true
                        // It shoud be load ok
                        // we just show alert when save failute :(
                    } else {
                        self.model = BBorrowBook(userbook: ub)
                    }
                }
            }
            .store(in: &cancellables)
    }
}
