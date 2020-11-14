//
//  MessageManager.swift
//  Business
//
//  Created by Phucnh on 11/13/20.
//

import Combine

public class MessageManager {
    
    private let networkRequest: MessageRequest
    
    // Publisher for fetch notifies of current user in session
    public let saveMessPublisher: PassthroughSubject<EMessage, Never>
    
    public init() {
        // Init resource URL
        networkRequest = MessageRequest(componentPath: "messages/")
        
        saveMessPublisher = PassthroughSubject<EMessage, Never>()
    }
    
    public func saveMess(message: EMessage) {
        networkRequest.saveMessage(message: message, publisher: saveMessPublisher)
    }
}
