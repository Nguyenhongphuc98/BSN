//
//  BorrowBookManager.swift
//  Business
//
//  Created by Phucnh on 11/9/20.
//

import Combine

public class BorrowBookManager {
    
    private let networkRequest: BorrowBookRequest
    
    // Publisher for save new bb and update bb action
    public let changePublisher: PassthroughSubject<EBorrowBook, Never>
    
    // Publisher for get single bb
    public let getBorrowBookPublisher: PassthroughSubject<EBorrowBook, Never>
    
    // Publisher for fetch borrowbooks by ...
    public let getBorrowBooksPublisher: PassthroughSubject<[EBorrowBook], Never>
    
    public init() {
        // Init resource URL
        networkRequest = BorrowBookRequest(componentPath: "borrowBooks/")
        
        changePublisher = PassthroughSubject<EBorrowBook, Never>()
        getBorrowBookPublisher = PassthroughSubject<EBorrowBook, Never>()
        getBorrowBooksPublisher = PassthroughSubject<[EBorrowBook], Never>()
    }
    
    public func saveBorrowBook(borrowBook: EBorrowBook) {
        networkRequest.saveBorrowBook(borrowBook: borrowBook, publisher: changePublisher)
    }
    
    public func updateBorrowBook(borrowBook: EBorrowBook) {
        networkRequest.updateBorrowBook(borrowBook: borrowBook, publisher: changePublisher)
    }
    
    public func getBorrowBook(bbid: String) {
        networkRequest.fetchBorowBook(bbid: bbid, publisher: getBorrowBookPublisher)
    }
    
    public func getHistoryBorrowBook() {
        networkRequest.fetchHistoryBorowBook(publisher: getBorrowBooksPublisher)
    }
}
