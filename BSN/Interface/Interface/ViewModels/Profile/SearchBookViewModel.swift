//
//  SearchAddBookViewModel.swift
//  Interface
//
//  Created by Phucnh on 10/11/20.
//

import SwiftUI
import Business
import Combine

class SearchBookViewModel: ObservableObject {
    
    @Published var searchText: String
    
    //@Published var searchBooks: [Book]
    @Published var searchBooks: [BBook]
    
    @Published var isSearching: Bool
    
    @Published var isfocus: Bool
    
    private var processText: String
    
    private var bookManager: BookManager
    
    //Cancellable
    var searchCancellables = Set<AnyCancellable>()
    
    init() {
        searchBooks = []
        searchText = ""
        isSearching = false
        isfocus = false
        processText = ""
        bookManager = BookManager.shared
        
        setupReceiveSearchBook()
    }
    
    func searchBook() {
        // Ignore any request when searching
        if !isSearching {
            isSearching = true
            
            // Make a lacenty for user type too fast
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.25) { [self] in
                // Clear action
                if searchText == "" {
                    if Thread.isMainThread {
                        searchBooks = []
                        isSearching = false
                    } else {
                        DispatchQueue.main.sync {
                            searchBooks = []
                            isSearching = false
                        }
                    }
                    return
                }
                
                // Store current state of searching text
                processText = searchText
                
                // Make a request to server
                bookManager.searchBook(term: processText)
            }
        }
    }
    
    func setupReceiveSearchBook() {
        print("Begin setup search book receive")
        bookManager
            .searchBooksPublisher
            .sink {[weak self] (sb) in
                
                guard let self = self else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.searchBooks = []
                    self.searchBooks = sb.map { (book) in
                        //Book(id: book.id, name: book.title, author: book.author, photo: book.cover)
                        BBook(id: book.id, title: book.title, author: book.author, cover: book.cover)
                    }
                    
                    self.isSearching = false
                }
                
                // This result is not lastest key
                // Try to continue searching
                if self.processText != self.searchText {
                    self.searchBook()
                }
            }
            .store(in: &searchCancellables)
        print("Finish setup search book receive")
    }
    
    private func filterInternalBook(key: String, complete: @escaping ([Book]) -> Void) {
        let result = fakebooks.filter { $0.name.contains(key) }
        complete(result)
    }
}
