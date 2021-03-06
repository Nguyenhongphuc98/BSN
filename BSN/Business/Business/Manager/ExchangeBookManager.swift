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
    public let changePublisher: PassthroughSubject<EExchangeBook, Never>
    
    // Publisher for fetch exchange books by page
    public let getExchangeBooksPublisher: PassthroughSubject<[EExchangeBook], Never>
    
    // Publisher for fetch exchange books by page
    public let getExchangeBookPublisher: PassthroughSubject<EExchangeBook, Never>
    
    public static let sharedCancel: ExchangeBookManager = .init()
    
    public init() {
        // Init resource URL
        resourceRequest = ExchangeBookRequest(componentPath: "exchangeBooks/")
        
        changePublisher = PassthroughSubject<EExchangeBook, Never>()
        getExchangeBooksPublisher = PassthroughSubject<[EExchangeBook], Never>()
        getExchangeBookPublisher = PassthroughSubject<EExchangeBook, Never>()
    }
    
    public func saveExchangeBook(eb: EExchangeBook) {
        resourceRequest.saveExchangeBook(eb: eb, publisher: changePublisher)
    }
    
    public func updateExchangeBook(eb: EExchangeBook) {
        resourceRequest.updateExchangeBook(eb: eb, publisher: changePublisher)
    }
    
    public func getNewestExchangeBooks(page: Int) {
        resourceRequest.fetchNewsestExchangeBooks(page: page, per: BusinessConfigure.exchangebookPerPage, publisher: getExchangeBooksPublisher)
    }
    
    public func getAvailableExchangeBooks(bid: String) {
        resourceRequest.fetchAvailableExchangeBooks(bid: bid, publisher: getExchangeBooksPublisher)
    }
    
    public func getComputeExchangeBook(ebid: String) {
        resourceRequest.fetchComputeExchangeBook(ebid: ebid, publisher: getExchangeBookPublisher)
    }
    
    public func getDetailExchangeBook(ebid: String) {
        resourceRequest.fetchDetailExchangeBook(ebid: ebid, publisher: getExchangeBookPublisher)
    }
    
    public func getHistoryExchangeBook() {
        resourceRequest.fetchHistoryExchangeBook(publisher: getExchangeBooksPublisher)
    }
    
    public func cancelExchangeReq(ebId: String) {
        resourceRequest.cancelExchangeReq(ebID: ebId)
    }
    
    public func getNewestExchangeBookOfUB(ubid: String) {
        resourceRequest.fetchExchangeBookOfUB(ubid: ubid, publisher: getExchangeBookPublisher)
    }
}
