//
//  ChatViewModel.swift
//  Interface
//
//  Created by Phucnh on 10/2/20.
//

import SwiftUI
import Business

public class ChatViewModel: NetworkViewModel {
    
    public static var shared: ChatViewModel = ChatViewModel()
    
    @Published public var chats: [Chat] {
        didSet {
            app.updateTabbar(chats: chats)
        }
    }
    
    @Published var searchText: String
    
    @Published var searchChats: [Chat]
    
    @Published var isfocus: Bool
    
    var processText: String
    
    var selectedUserNewChat: User
    
    private var chatManager: ChatManager
    
    private var app: AppManager
    
    override init() {
        chats = []
        searchChats = []
        searchText = ""
        isfocus = false
        processText = ""
        selectedUserNewChat = User(isDummy: true)
        chatManager = ChatManager()
        app = AppManager.shared
        
        super.init()
        observerRecentlyChats()
        observerSearchChats()
        //prepareData() Did call when login success
        observerReceiveNewChat()
    }
    
    public func prepareData() {
        print("did call prepare data for chat view")
        isLoading = true
        chatManager.getChats(page: 0, currentUid: AppManager.shared.currenUID) // Load recently chats
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
}

// MARK: - Observer data
extension ChatViewModel {
    // Receive first page
    private func observerRecentlyChats() {
        chatManager
            .getRecentlyChatsPublisher
            .sink {[weak self] (chats) in
                
                guard let self = self else {
                    return
                }
                
                DispatchQueue.main.async {
                    
                    self.chats = []
                    
                    chats.forEach { (c) in
                        
                        let mess = Message(content: c.messageContent!, type: c.messageTypeName!, createAt: c.messageCreateAt!)
                        let model = Chat(id: c.id,
                             partnerID: c.getPartnerID(of: AppManager.shared.currenUID),
                             partnerName: c.getPartnerName(of: AppManager.shared.currenUID),
                             partnerPhoto: c.getPartnerPhoto(of: AppManager.shared.currenUID),
                             lastMessage: mess,
                             seen: c.isSeen(of: AppManager.shared.currenUID)
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
                             lastMessage: mess,
                             seen: c.isSeen(of: AppManager.shared.currenUID)
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
    
    // WebSocket send Chat to receiver of chat
    // Chat maybe new or last message updated
    private func observerReceiveNewChat() {
        chatManager
            .receiveChatPublisher
            .sink {[weak self] (c) in
                
                guard let self = self else {
                    return
                }
                
                DispatchQueue.main.async {
                    let mess = Message(content: c.messageContent!, type: c.messageTypeName!, createAt: c.messageCreateAt!)
                    let model = Chat(id: c.id,
                         partnerID: c.getPartnerID(of: AppManager.shared.currenUID),
                         partnerName: c.getPartnerName(of: AppManager.shared.currenUID),
                         partnerPhoto: c.getPartnerPhoto(of: AppManager.shared.currenUID),
                         lastMessage: mess,
                         seen: c.isSeen(of: AppManager.shared.currenUID)
                    )
                    
                    let index = self.chats.firstIndex { $0.id == model.id }
                    if let i = index {
                        // This chat aleady in list, just update content, time, and move to top
                        // In short, remove and insert new
                        self.chats.remove(at: i)
                    }
                    
                    // Anyway, new chat should be in top
                    self.chats.insert(model, at: 0)                    
                    self.objectWillChange.send()
                }
            }
            .store(in: &cancellables)
    }
}
