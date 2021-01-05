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
    
    // Observer new message come
    public let receiveMessPublisher: PassthroughSubject<EMessage, Never>
    private let webSocket: SocketFollow<EMessage>
    
    public init() {
        // Init resource URL
        networkRequest = MessageRequest(componentPath: "messages/")
        
        // Load resource
        saveMessPublisher = PassthroughSubject<EMessage, Never>()
        getMessagesPublisher = PassthroughSubject<[EMessage], Never>()
        
        //Websocket
        receiveMessPublisher = PassthroughSubject<EMessage, Never>()
        webSocket = SocketFollow()
    }
    
    public func saveMess(message: EMessage) {
        networkRequest.saveMessage(message: message, publisher: saveMessPublisher)
    }
    
    public func connectWebSocket(chatID: String) {
        webSocket.connect(url: wsInChatApi + chatID)
        webSocket.didReceiveData = { message in
            print("Business did receive new message: \(message.content)")
            self.receiveMessPublisher.send(message)
        }
    }
    
    public func getMessages(page: Int, per: Int = BusinessConfigure.newestMessagesPerPage, chatID: String) {
        if page == 0 {
            // Setup receive data for first time fetch data
            connectWebSocket(chatID: chatID)
        }
        networkRequest.fetchMessages(page: page, per: per, chatID: chatID, publisher: getMessagesPublisher)
    }
}
