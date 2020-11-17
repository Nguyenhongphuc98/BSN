//
//  DeclineBorrowBookViewModel.swift
//  Interface
//
//  Created by Phucnh on 10/8/20.
//

import SwiftUI
import Business

class DeclineEoBBookViewModel: ObservableObject {
    
    @Published var declineMessage: String
    
    private var borrowBookManager: BorrowBookManager
    
    init() {
        declineMessage = ""
        borrowBookManager = BorrowBookManager()
    }
    
    // We assume it will update success
    // Don't care result
    func processDecline(isborrow: Bool, targetID: String) {
        if isborrow {
            // Just care id to find info
            // Message (as reason) and state
            let ebb = EBorrowBook(id: targetID, message: declineMessage, state: ExchangeProgess.decline.rawValue)
            borrowBookManager.updateBorrowBook(borrowBook: ebb)
        }
    }
}
