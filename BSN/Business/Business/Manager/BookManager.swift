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
    
    // Get single book
    public let bookPublisher: PassthroughSubject<Book, Never>
    
    public init() {
        // Publisher
        searchBooksPublisher = PassthroughSubject<[SearchBook], Never>()
        
        // Init resource URL
        searchBooksRequest = ResourceRequest<SearchBook>(componentPath: "books/")
        booksRequest = ResourceRequest<Book>(componentPath: "books/")
        
        // Google
        bookPublisher = PassthroughSubject<Book, Never>()
    }
    
    // Request books with title or author `term`
    public func searchBook(term: String) {
        print("Did start searching books")
        searchBooksRequest.searchBook(term: term, publisher: searchBooksPublisher)
    }
    
    // Request book with ID from Our Server
    public func fetchBook(bookID: String) {
        print("Did start fetch book: \(bookID)")
        booksRequest.fetchBook(bookID: bookID, publisher: bookPublisher)
    }
    
    // Fetch from google api
    public func getBookInfo(by isbn: String) {
        GoogleApiRequest
            .shared
            .getBookInfo(by: isbn, publisher: bookPublisher)
    }
}
