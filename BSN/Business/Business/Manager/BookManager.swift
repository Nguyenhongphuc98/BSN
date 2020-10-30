//
//  BookManager.swift
//  Business
//
//  Created by Phucnh on 10/20/20.
//

import Combine

public class BookManager {
    
    public static let shared: BookManager = BookManager()
    
    private let searchBooksRequest: SearchBookRequest
    
    private let booksRequest: BookRequest
    
    // List book searched from DB
    public let searchBooksPublisher: PassthroughSubject<[SearchBook], Never>
    
    // Get single book from server
    public let getBookPublisher: PassthroughSubject<Book, Never>
    
    // Get single book from google api
    public let getGoogleBookPublisher: PassthroughSubject<Book, Never>
    
    public let getBookByIsbnPublisher: PassthroughSubject<SearchBook, Never>
    
    public let saveBookPublisher: PassthroughSubject<Book, Never>
    
    public init() {
        // Publisher
        searchBooksPublisher = PassthroughSubject<[SearchBook], Never>()
        
        // Init resource URL
        searchBooksRequest = SearchBookRequest(componentPath: "books/")
        booksRequest = BookRequest(componentPath: "books/")
        
        getBookPublisher = PassthroughSubject<Book, Never>()
        getGoogleBookPublisher = PassthroughSubject<Book, Never>()
        getBookByIsbnPublisher = PassthroughSubject<SearchBook, Never>()
        saveBookPublisher = PassthroughSubject<Book, Never>()
    }
    
    // Request books with title or author `term`
    public func searchBook(term: String) {
        print("Did start searching books")
        searchBooksRequest.searchBook(term: term, publisher: searchBooksPublisher)
    }
    
    // Request book with ID from Our Server
    public func fetchBook(bookID: String) {
        print("Did start fetch book id: \(bookID)")
        booksRequest.fetchBook(bookID: bookID, publisher: getBookPublisher)
    }
    
    public func fetchBook(isbn: String) {
        print("Did start fetch book isbn: \(isbn)")
        searchBooksRequest.searchBook(isbn: isbn, publisher: getBookByIsbnPublisher)
    }
    
    public func saveBook(book: Book) {
        print("Did start save book \(book.title)")
        booksRequest.saveBook(book: book, publisher: saveBookPublisher)
    }
    
    // Fetch from google api
    public func getBookInfo(by isbn: String) {
        GoogleApiRequest
            .shared
            .getBookInfo(by: isbn, publisher: getGoogleBookPublisher)
    }
}
