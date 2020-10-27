//
//  BookManager.swift
//  Business
//
//  Created by Phucnh on 10/20/20.
//

import Combine

public class BookManager {
    
    public static let shared: BookManager = BookManager()
    
    private let searchBooksRequest: ResourceRequest<SearchBook>
    
    private let booksRequest: ResourceRequest<Book>
    
    // List book searched from DB
    public let searchBooksPublisher: PassthroughSubject<[SearchBook], Never>
    
    // Get book info by isbn from google api
    public let googleBookPublisher: PassthroughSubject<Book, Never>
    
    public init() {
        // Publisher
        searchBooksPublisher = PassthroughSubject<[SearchBook], Never>()
        
        // Init resource URL
        searchBooksRequest = ResourceRequest<SearchBook>(componentPath: "books/")
        booksRequest = ResourceRequest<Book>(componentPath: "books/")
        
        // Google
        googleBookPublisher = PassthroughSubject<Book, Never>()
    }
    
    // Request book with title or author `term`
    public func searchBook(term: String) {
        print("Did start searching books")
        searchBooksRequest.searchBook(term: term, publisher: searchBooksPublisher)
    }
    
    public func getBookInfo(by isbn: String) {
        GoogleApiRequest
            .shared
            .getBookInfo(by: isbn, publisher: googleBookPublisher)
    }
}
