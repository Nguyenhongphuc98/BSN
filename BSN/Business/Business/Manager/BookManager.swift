//
//  BookManager.swift
//  Business
//
//  Created by Phucnh on 10/20/20.
//

import Combine

public class BookManager {
    
    public static let shared: BookManager = BookManager()
    
    private let acronymsRequest: ResourceRequest<SearchBook>
    
    public let searchBooksPublisher: PassthroughSubject<[SearchBook], Never>
    
    public init() {
        searchBooksPublisher = PassthroughSubject<[SearchBook], Never>()
        acronymsRequest = ResourceRequest<SearchBook>(componentPath: "books/")
    }
    
    // Request book with title or author `term`
    public func searchBook(term: String) {
        acronymsRequest.searchBook(term: term, publisher: searchBooksPublisher)
    }
}
