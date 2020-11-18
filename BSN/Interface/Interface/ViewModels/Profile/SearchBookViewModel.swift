//
//  SearchAddBookViewModel.swift
//  Interface
//
//  Created by Phucnh on 10/11/20.
//

import SwiftUI
import Business
import Combine

public class SearchBookViewModel: NetworkViewModel {
    
    //@Published var searchText: String
    var searchText: String
    
    //@Published var searchBooks: [Book]
    @Published var searchBooks: [BBook]
    
    //@Published var isSearching: Bool
    
    @Published var isfocus: Bool
    
    private var processText: String
    
    private var bookManager: BookManager
    
    //Cancellable
    //var cancellables = Set<AnyCancellable>()
    
    override init() {
        searchBooks = []
        searchText = ""
        //isSearching = false
        isfocus = false
        processText = ""
        bookManager = BookManager.shared
        
        super.init()
        
        setupReceiveSearchBook()
    }
    
    func searchBook(text: String) {
        searchText = text
        // Ignore any request when searching
//        if !isSearching {
//            isSearching = true
        if !isLoading {
            isLoading = true
            
            // Make a lacenty for user type too fast
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.25) { [self] in
                // Clear action
                if searchText == "" {
                    if Thread.isMainThread {
                        searchBooks = []
                        //isSearching = false
                        isLoading = false
                    } else {
                        DispatchQueue.main.sync {
                            searchBooks = []
                            //isSearching = false
                            isLoading = false
                        }
                    }
                    return
                }
                
                // Store current state of searching text
                processText = searchText
                
                // Make a request to server
                bookManager.searchBook(term: processText)
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                    self.searchBooks = [BBook(), BBook()]
//                    self.isSearching = false
//                }
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
                        
                        BBook(id: book.id, title: book.title, author: book.author, cover: book.cover)
                    }
                    
                    //self.isSearching = false
                    self.isLoading = false
                    self.objectWillChange.send()
                }
                
                // This result is not lastest key
                // Try to continue searching
                if self.processText != self.searchText {
                    self.searchBook(text: self.searchText)
                }
            }
            .store(in: &cancellables)
        print("Finish setup search book receive")
    }
    
    private func filterInternalBook(key: String, complete: @escaping ([BBook]) -> Void) {
        let result = fakebooks.filter { $0.title.contains(key) }
        complete(result)
    }
}
