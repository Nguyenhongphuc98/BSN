//
//  SearchViewViewModel.swift
//  Interface
//
//  Created by Phucnh on 10/5/20.
//

import SwiftUI

class SearchViewViewModel: ObservableObject {
    
    @Published var books: [Book]
    
    @Published var searchText: String
    
    @Published var searchBooks: [Book]
    
    @Published var isSearching: Bool
    
    @Published var isfocus: Bool
    
    var processText: String
    
    init() {
        books = [Book(), Book(), Book(), Book(), Book(), Book(), Book()]
        searchBooks = []
        searchText = ""
        isSearching = false
        isfocus = false
        processText = ""
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
                        complete(true)
                    }
                }
            }
        }
    }
    
    private func filterInternalBook(key: String, complete: @escaping ([Book]) -> Void) {
        let result = books.filter { $0.name.contains(key) }
        complete(result)
    }
}
