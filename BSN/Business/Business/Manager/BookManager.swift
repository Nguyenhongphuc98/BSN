//
//  BookManager.swift
//  Business
//
//  Created by Phucnh on 10/20/20.
//

import Combine

public class BookManager {
    
    public static let shared: BookManager = BookManager()
    
    private let booksRequest: ResourceRequest<SearchBook>
    
    public let searchBooksPublisher: PassthroughSubject<[SearchBook], Never>
    
    public init() {
        searchBooksPublisher = PassthroughSubject<[SearchBook], Never>()
        booksRequest = ResourceRequest<SearchBook>(componentPath: "books/")
    }
    
    // Request book with title or author `term`
    public func searchBook(term: String) {
        print("Did start searching books")
        booksRequest.searchBook(term: term, publisher: searchBooksPublisher)
    }
}
