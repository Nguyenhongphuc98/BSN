//
//  BorrowBookManager.swift
//  Business
//
//  Created by Phucnh on 11/9/20.
//

import Combine

public class BorrowBookManager {
    
    private let networkRequest: BorrowBookRequest
    
    // Publisher for save new note and update note action
    public let changePublisher: PassthroughSubject<EBorrowBook, Never>
    
    // Publisher for fetch notes by ubid
    public let getBorrowBooksPublisher: PassthroughSubject<[EBorrowBook], Never>
    
    public init() {
        // Init resource URL
        networkRequest = BorrowBookRequest(componentPath: "borrowBooks/")
        
        changePublisher = PassthroughSubject<EBorrowBook, Never>()
        getBorrowBooksPublisher = PassthroughSubject<[EBorrowBook], Never>()
    }
    
    public func saveBorrowBook(borrowBook: EBorrowBook) {
        networkRequest.saveBorrowBook(borrowBook: borrowBook, publisher: changePublisher)
    }
}
