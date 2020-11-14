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
    
    //@Published var isSearching: Bool
    
    @Published var isfocus: Bool
    
    var processText: String
    
    var selectedUserNewChat: User
    
    private var chatManager: ChatManager
    
    override init() {
        chats = []
        searchChats = []
        searchText = ""
        //isSearching = false
        isfocus = false
        processText = ""
        selectedUserNewChat = User(isDummy: true)
        chatManager = ChatManager()
        
        super.init()
        setupReceiveRecentlyChats()
        prepareData()
    }
    
    func prepareData() {
        print("did call prepare data for chat view")
        isLoading = true
        // Load recently chats
        chatManager.getChats(page: 0)
    }
    
    func setupReceiveRecentlyChats() {
        chatManager
            .getChatsPublisher
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
    
//    func searchChat(complete: @escaping (Bool) -> Void) {
//        // Clear action
//        if searchText == "" {
//            searchChats = []
//            isSearching = false
//            complete(false)
//            return
//        }
//
//        // Ignore any request when searching
//        if !isSearching {
//            isSearching = true
//
//            // Make a lacenty for user type too fast
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { [self] in
//                processText = searchText
//                // To-Do
//                // Call BL process and get result
//
//                //EX data
//                filterInternalChat(key: processText) { (data) in
//                    isSearching = false
//                    searchChats = data
//
//                    // This result is not lastest key
//                    // Try to continue searching
//                    if processText != searchText {
//                        searchChat { (success) in
//                            complete(success)
//                        }
//                    } else {
//                        complete(true)
//                    }
//                }
//            }
//        }
//    }
    
//    private func filterInternalChat(key: String, complete: @escaping ([Chat]) -> Void) {
//        let result = chats.filter { $0.partnerName.contains(key) }
//        complete(result)
//    }
}
