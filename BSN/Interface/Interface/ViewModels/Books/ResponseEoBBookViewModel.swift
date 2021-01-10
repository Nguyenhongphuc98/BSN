//
//  DeclineBorrowBookViewModel.swift
//  Interface
//
//  Created by Phucnh on 10/8/20.
//

import SwiftUI
import Business

class ResponseEoBBookViewModel: ObservableObject {
    
    @Published var declineMessage: String
    
    private var borrowBookManager: BorrowBookManager
    
    private var exchangeBookManager: ExchangeBookManager
    
    init() {
        declineMessage = ""
        borrowBookManager = BorrowBookManager()
        exchangeBookManager = ExchangeBookManager()
    }
    
    // We assume it will update success
    // Don't care result
    func processDecline(isborrow: Bool, targetID: String) {
        if isborrow {
            // Just care id to find info
            // Message (as reason) and state
            let ebb = EBorrowBook(
                id: targetID,
                responseMessage: declineMessage,
                state: ExchangeProgess.decline.rawValue
            )
            borrowBookManager.updateBorrowBook(borrowBook: ebb)
        } else {
            // Exchange
            let eeb = EExchangeBook(
                id: targetID,
                responseMessage: declineMessage,
                state: ExchangeProgess.decline.rawValue
            )
            exchangeBookManager.updateExchangeBook(eb: eeb)
        }
    }
    
    // We assume it will update success
    // Don't care result
    func processAccept(isborrow: Bool, targetID: String) {
        if isborrow {
            // Just care id to find info
            // Message (as reason) and state
            let ebb = EBorrowBook(
                id: targetID,
                responseMessage: declineMessage,
                state: ExchangeProgess.accept.rawValue
            )
            borrowBookManager.updateBorrowBook(borrowBook: ebb)
        } else {
            // Exchange
            let eeb = EExchangeBook(
                id: targetID,
                responseMessage: declineMessage,
                state: ExchangeProgess.accept.rawValue
            )
            exchangeBookManager.updateExchangeBook(eb: eeb)
        }
    }
}
