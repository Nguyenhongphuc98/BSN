//
//  NewChatViewModel.swift
//  Interface
//
//  Created by Phucnh on 10/3/20.
//

import SwiftUI
import Business

class NewChatViewModel: NetworkViewModel {
    
    @Published var searchedContacts: [User]
    
    @Published var isFocus: Bool
    
    @Published var searchText: String
    
    var processText: String
    
    private var userFollowManager: UserFollowManager
    
    override init() {
        isFocus = false
        searchText = ""
        processText = ""
        searchedContacts = []
        userFollowManager = UserFollowManager()
        
        super.init()
        setupReceiveSearchUser()
    }
    
    func searchUser() {
        // Ignore any request when searching
        if !isLoading {
            isLoading = true
            
            // Make a lacenty for user type too fast
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.25) { [self] in
                // Clear action
                if searchText == "" {
                    processText = ""
                    if Thread.isMainThread {
                        searchedContacts = []
                        isLoading = false
                    } else {
                        DispatchQueue.main.sync {
                            searchedContacts = []
                            isLoading = false
                        }
                    }
                    return
                }
                
                // Store current state of searching text
                processText = searchText
                
                // Make a request to server
                userFollowManager.getFollowing(followerID: AppManager.shared.currenUID, name: processText)
            }
        }
    }
    
    func setupReceiveSearchUser() {
        userFollowManager
            .getFollowingsPublisher
            .sink {[weak self] (sb) in
                
                guard let self = self else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.searchedContacts = []
                    self.searchedContacts = sb.map { (u) in
                        User(id: u.userID!, photo: u.userPhoto, name: u.userName!)
                    }
                    
                    self.isLoading = false
                    self.objectWillChange.send()
                }
                
                // This result is not lastest key
                // Try to continue searching
                if self.processText != self.searchText {
                    self.searchUser()
                }
            }
            .store(in: &cancellables)
    }
}
