//
//  NewChatViewModel.swift
//  Interface
//
//  Created by Phucnh on 10/3/20.
//

import SwiftUI

class NewChatViewModel: ObservableObject {
    
    @Published var coreContacts: [User]
    
    @Published var displayContacts: [User]
    
    @Published var isFocus: Bool
    
    @Published var searchText: String
    
    init() {
        coreContacts = [User(), User(), User(), User(), User(), User(), User(), User(), User(), User(), User(), User(), User(), User(), User(), User(), User()]
        isFocus = false
        searchText = ""
        displayContacts = []
        displayContacts = coreContacts
    }
    
    func searchChat(complete: @escaping (Bool) -> Void) {
        // Clear action
        if searchText == "" {
            displayContacts = coreContacts
            complete(true)
            return
        }
        
        displayContacts = coreContacts.filter { $0.displayname.contains(searchText) }
        complete(displayContacts.isEmpty)
    }
}
