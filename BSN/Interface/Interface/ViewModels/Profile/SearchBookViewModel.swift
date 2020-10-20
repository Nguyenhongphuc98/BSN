//
//  SearchAddBookViewModel.swift
//  Interface
//
//  Created by Phucnh on 10/11/20.
//

import SwiftUI
import Business

class SearchBookViewModel: ObservableObject {
    
    @Published var searchText: String
    
    @Published var searchBooks: [Book]
    
    @Published var isSearching: Bool
    
    @Published var isfocus: Bool
    
    var processText: String
    
    var bookManager: BookManager
    
    init() {
        searchBooks = []
        searchText = ""
        isSearching = false
        isfocus = false
        processText = ""
        bookManager = BookManager.shared
    }
    
    func searchBook(complete: @escaping (Bool) -> Void) {
        // Clear action
        if searchText == "" {
            searchBooks = []
            isSearching = false
            complete(false)
            return
        }
        
        // Ignore any request when searching
        if !isSearching {
            isSearching = true
            
            bookManager.searchBook(term: "Ph")
            
            // Make a lacenty for user type too fast
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { [self] in
                processText = searchText
                // To-Do
                // Call BL process and get result
                
                //EX data
                filterInternalBook(key: processText) { (data) in
                    isSearching = false
                    searchBooks = data
                    
                    // This result is not lastest key
                    // Try to continue searching
                    if processText != searchText {
                        searchBook { (success) in
                            complete(success)
                        }
                    } else {
                        complete(searchBooks.count != 0)
                    }
                }
            }
        }
    }
    
    private func filterInternalBook(key: String, complete: @escaping ([Book]) -> Void) {
        let result = fakebooks.filter { $0.name.contains(key) }
        complete(result)
    }
}
