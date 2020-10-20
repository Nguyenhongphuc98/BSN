//
//  BookManager.swift
//  Business
//
//  Created by Phucnh on 10/20/20.
//

public class BookManager {
    
    public static let shared: BookManager = BookManager()
    
    var searchBooks: [SearchBook]
    let acronymsRequest: ResourceRequest<SearchBook>
    
    public init() {
        searchBooks = []
        acronymsRequest = ResourceRequest<SearchBook>(componentPath: "books/")
    }
    
    public func searchBook(term: String) {
        acronymsRequest.searchBook(term: term) {
            
        }
    }
}
