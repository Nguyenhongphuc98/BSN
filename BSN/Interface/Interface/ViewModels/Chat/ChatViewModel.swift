//
//  ChatViewModel.swift
//  Interface
//
//  Created by Phucnh on 10/2/20.
//

import SwiftUI
import Business

class ChatViewModel: NetworkViewModel {
    
    @Published var chats: [Chat]
    
    @Published var searchText: String
    
    @Published var searchChats: [Chat]
    
    @Published var isfocus: Bool
    
    var processText: String
    
    var selectedUserNewChat: User
    
    private var chatManager: ChatManager
    
    override init() {
        chats = []
        searchChats = []
        searchText = ""
        isfocus = false
        processText = ""
        selectedUserNewChat = User(isDummy: true)
        chatManager = ChatManager()
        
        super.init()
        observerRecentlyChats()
        observerSearchChats()
        prepareData()
    }
    
    func prepareData() {
        print("did call prepare data for chat view")
        isLoading = true
        chatManager.getChats(page: 0) // Load recently chats
    }
    
    func searchChat() {
        // Ignore any request when searching
        if !isLoading {
            isLoading = true
            
            // Make a lacenty for user type too fast
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.25) { [self] in
                // Clear action
                if searchText == "" {
                    processText = ""
                    if Thread.isMainThread {
                        searchChats = []
                        isLoading = false
                    } else {
                        DispatchQueue.main.sync {
                            searchChats = []
                            isLoading = false
                        }
                    }
                    return
                }
                
                // Store current state of searching text
                processText = searchText
                
                // Make a request to server
                chatManager.getChats(partnerName: processText)
            }
        }
    }
    
//    private func filterInternalChat(key: String, complete: @escaping ([Chat]) -> Void) {
//        let result = chats.filter { $0.partnerName.contains(key) }
//        complete(result)
//    }
}

// MARK: - Observer data
extension ChatViewModel {
    private func observerRecentlyChats() {
        chatManager
            .getRecentlyChatsPublisher
            .sink {[weak self] (chats) in
                
                guard let self = self else {
                    return
                }
                
                DispatchQueue.main.async {
                    
                    chats.forEach { (c) in
                        
                        let mess = Message(content: c.messageContent!, type: c.messageTypeName!, createAt: c.messageCreateAt!)
                        let model = Chat(id: c.id,
                             partnerID: c.getPartnerID(of: AppManager.shared.currenUID),
                             partnerName: c.getPartnerName(of: AppManager.shared.currenUID),
                             partnerPhoto: c.getPartnerPhoto(of: AppManager.shared.currenUID),
                             lastMessage: mess
                        )
                        
                        self.chats.appendUnique(item: model)
                    }
                    
                    self.isLoading = false
                    self.objectWillChange.send()
                }
            }
            .store(in: &cancellables)
    }
    
    private func observerSearchChats() {
        chatManager
            .getSearchChatsPublisher
            .sink {[weak self] (chats) in
                
                guard let self = self else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.searchChats = []
                    chats.forEach { (c) in
                        
                        let mess = Message(content: c.messageContent!, type: c.messageTypeName!, createAt: c.messageCreateAt!)
                        let model = Chat(id: c.id,
                             partnerID: c.getPartnerID(of: AppManager.shared.currenUID),
                             partnerName: c.getPartnerName(of: AppManager.shared.currenUID),
                             partnerPhoto: c.getPartnerPhoto(of: AppManager.shared.currenUID),
                             lastMessage: mess
                        )
                        
                        self.searchChats.append(model)
                    }
                    
                    self.isLoading = false
                    self.objectWillChange.send()
                    
                    if self.processText != self.searchText {
                        self.searchChat()
                    }
                }
            }
            .store(in: &cancellables)
    }
}
