//
//  ExchangeBookManager.swift
//  Business
//
//  Created by Phucnh on 10/30/20.
//

import Combine

public class ExchangeBookManager {
    
    public static let shared: ExchangeBookManager = ExchangeBookManager()
    
    private let resourceRequest: ExchangeBookRequest
    
    // Publisher for save new exchange book action
    public let savePublisher: PassthroughSubject<EExchangeBook, Never>
    
    // Publisher for fetch exchange book by page
    public let getExchangeBooksPublisher: PassthroughSubject<[EExchangeBook], Never>
    
    public init() {
        // Init resource URL
        resourceRequest = ExchangeBookRequest(componentPath: "exchangeBooks/")
        //exchangeFullRequest = ExchangeBookFullRequest(componentPath: "exchangeBooks/")
        
        savePublisher = PassthroughSubject<EExchangeBook, Never>()
        getExchangeBooksPublisher = PassthroughSubject<[EExchangeBook], Never>()
    }
    
    public func saveExchangeBook(eb: EExchangeBook) {
        resourceRequest.saveExchangeBook(eb: eb, publisher: savePublisher)
    }
    
    public func getExchangeBooks(page: Int) {
        resourceRequest.fetchExchangeBooks(page: page, per: BusinessConfigure.exchangebookPerPage, publisher: getExchangeBooksPublisher)
        
    }
}
