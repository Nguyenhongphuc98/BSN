//
//  ChatManager.swift
//  Business
//
//  Created by Phucnh on 11/14/20.
//
import Combine

public class ChatManager {
    
    private let networkRequest: ChatRequest
    
    // Publisher for fetch notifies of current user in session
    public let getChatsPublisher: PassthroughSubject<[EChat], Never>
    
    public init() {
        // Init resource URL
        networkRequest = ChatRequest(componentPath: "chats/")
        
        getChatsPublisher = PassthroughSubject<[EChat], Never>()
    }
    
    public func getChats(page: Int, per: Int = BusinessConfigure.newestChatsPerPage) {
        networkRequest.getNewestChats(page: page, per: per, publisher: getChatsPublisher)
    }
}
