//
//  ChatViewModel.swift
//  Interface
//
//  Created by Phucnh on 10/2/20.
//

import SwiftUI

class ChatViewModel: ObservableObject {
    
    @Published var chats: [Chat]
    
    @Published var searchText: String
    
    @Published var searchChats: [Chat]
    
    @Published var isSearching: Bool
    
    @Published var isfocus: Bool
    
    var processText: String
    
    var selectedUserNewChat: User
    
    init() {
        chats = [Chat(), Chat()]
        searchChats = []
        searchText = ""
        isSearching = false
        isfocus = false
        processText = ""
        selectedUserNewChat = User(isDummy: true)
    }
    
    func searchChat(complete: @escaping (Bool) -> Void) {
        // Clear action
        if searchText == "" {
            searchChats = []
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
                filterInternalChat(key: processText) { (data) in
                    isSearching = false
                    searchChats = data
                    
                    // This result is not lastest key
                    // Try to continue searching
                    if processText != searchText {
                        searchChat { (success) in
                            complete(success)
                        }
                    } else {
                        complete(true)
                    }
                }
            }
        }
    }
    
    private func filterInternalChat(key: String, complete: @escaping ([Chat]) -> Void) {
        let result = chats.filter { $0.partnerName.contains(key) }
        complete(result)
    }
}
