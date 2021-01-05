//
//  ChatManager.swift
//  Business
//
//  Created by Phucnh on 11/14/20.
//
import Combine

public class ChatManager {
    
    // Just use for update feature
    // Because it don't need care result, so should reuse it
    public static var sharedUpdate: ChatManager = .init()
    
    private let networkRequest: ChatRequest
    
    // Publisher for fetch chats of current user in session
    public let getRecentlyChatsPublisher: PassthroughSubject<[EChat], Never>
    public let getSearchChatsPublisher: PassthroughSubject<[EChat], Never>
    public let getChatPublisher: PassthroughSubject<EChat, Never>
    
    // Observer new Chat or chat updated by server insert new message
    public let receiveChatPublisher: PassthroughSubject<EChat, Never>
    private let webSocket: SocketFollow<EChat>
    
    public init() {
        // Init resource URL
        networkRequest = ChatRequest(componentPath: "chats/")
        
        getRecentlyChatsPublisher = PassthroughSubject<[EChat], Never>()
        getSearchChatsPublisher = PassthroughSubject<[EChat], Never>()
        getChatPublisher = PassthroughSubject<EChat, Never>()
        
        // WebSocket
        receiveChatPublisher = PassthroughSubject<EChat, Never>()
        webSocket = SocketFollow()
    }
    
    public func connectWebSocket(uid: String) {
        webSocket.connect(url: wsChatsApi + uid)
        webSocket.didReceiveData = { chat in
            print("Business did receive new chat with message: \(chat.messageContent!)")
            self.receiveChatPublisher.send(chat)
        }
    }
    
    // This result should show in chat view (list recently chat)
    public func getChats(page: Int, per: Int = BusinessConfigure.newestChatsPerPage, currentUid: String) {
        if page == 0 {
            // Setup receive data for first time fetch data
            connectWebSocket(uid: currentUid)
        }
        networkRequest.getNewestChats(page: page, per: per, publisher: getRecentlyChatsPublisher)
    }
    
    public func getChats(partnerName: String) {
        networkRequest.searchChats(partnerName: partnerName, publisher: getSearchChatsPublisher)
    }
    
    public func getChat(uid1: String, uid2: String) {
        networkRequest.getChat(uid1: uid1, uid2: uid2, publisher: getChatPublisher)
    }
    
    public func updateChat(chat: EChat) {
        networkRequest.updateChat(chat: chat)
    }
}
