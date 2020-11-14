//
//  MessageManager.swift
//  Business
//
//  Created by Phucnh on 11/13/20.
//

import Combine

public class MessageManager {
    
    private let networkRequest: MessageRequest
    
    // Publisher for save message
    public let saveMessPublisher: PassthroughSubject<EMessage, Never>
    
    public let getMessagesPublisher: PassthroughSubject<[EMessage], Never>
    
    public init() {
        // Init resource URL
        networkRequest = MessageRequest(componentPath: "messages/")
        
        saveMessPublisher = PassthroughSubject<EMessage, Never>()
        getMessagesPublisher = PassthroughSubject<[EMessage], Never>()
    }
    
    public func saveMess(message: EMessage) {
        networkRequest.saveMessage(message: message, publisher: saveMessPublisher)
    }
    
    public func getMessages(page: Int, per: Int = BusinessConfigure.newestChatsPerPage, chatID: String) {
        networkRequest.fetchMessages(page: page, per: per, chatID: chatID, publisher: getMessagesPublisher)
    }
}
