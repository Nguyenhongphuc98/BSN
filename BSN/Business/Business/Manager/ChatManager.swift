//
//  ChatManager.swift
//  Business
//
//  Created by Phucnh on 11/14/20.
//
import Combine

public class ChatManager {
    
    private let networkRequest: ChatRequest
    
    // Publisher for fetch chats of current user in session
    public let getRecentlyChatsPublisher: PassthroughSubject<[EChat], Never>
    
    public let getSearchChatsPublisher: PassthroughSubject<[EChat], Never>
    
    public let getChatPublisher: PassthroughSubject<EChat, Never>
    
    public init() {
        // Init resource URL
        networkRequest = ChatRequest(componentPath: "chats/")
        
        getRecentlyChatsPublisher = PassthroughSubject<[EChat], Never>()
        getSearchChatsPublisher = PassthroughSubject<[EChat], Never>()
        getChatPublisher = PassthroughSubject<EChat, Never>()
    }
    
    public func getChats(page: Int, per: Int = BusinessConfigure.newestChatsPerPage) {
        networkRequest.getNewestChats(page: page, per: per, publisher: getRecentlyChatsPublisher)
    }
    
    public func getChats(partnerName: String) {
        networkRequest.searchChats(partnerName: partnerName, publisher: getSearchChatsPublisher)
    }
    
    public func getChat(uid1: String, uid2: String) {
        networkRequest.getChat(uid1: uid1, uid2: uid2, publisher: getChatPublisher)
    }
}
