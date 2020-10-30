//
//  ExchangeBookManager.swift
//  Business
//
//  Created by Phucnh on 10/30/20.
//

import Combine

public class ExchangeBookManager {
    
    public static let shared: ExchangeBookManager = ExchangeBookManager()
    
    private let networkRequest: ExchangeBookRequest
    
    // Publisher for save new exchange book action
    public let savePublisher: PassthroughSubject<ExchangeBook, Never>
    
    // Publisher for fetch exchange book by page
    public let getExchangeBooksPublisher: PassthroughSubject<[ExchangeBook], Never>
    
    public init() {
        // Init resource URL
        networkRequest = ExchangeBookRequest(componentPath: "exchangeBooks/")
        
        savePublisher = PassthroughSubject<ExchangeBook, Never>()
        getExchangeBooksPublisher = PassthroughSubject<[ExchangeBook], Never>()
    }
    
    public func saveExchangeBook(eb: ExchangeBook) {
        networkRequest.saveExchangeBook(eb: eb, publisher: savePublisher)
    }
    
//    public func getUserBooks(uid: String) {
//        networkRequest.fetchUserBooks(uid: uid, publisher: getExchangeBooksPublisher)
//    }
}
