//
//  InChatViewModel.swift
//  Interface
//
//  Created by Phucnh on 10/2/20.
//

import SwiftUI

class InChatViewModel: NetworkViewModel {
    
    @Published var messages: [Message]
    
    @Published var chat: Chat
    
    // Photo to send if select from gallery
    @Published var photo: Data
    
    // Did send new message
    // It's content should be force UI scroll to bottom
    var updateUIIfNeedes: (() -> Void)?
    
    override init() {
        messages = []
        chat = Chat()
        photo = Data()
        
        super.init()
    }
    
    func fetchData(chat: Chat) {
        self.isLoading = true
        self.chat = chat
        
        if self.chat.id != kUndefine {
            // fetch message of this chat
        } else {
            // Get chat info by curren user and parter user
            // It called usualy because user search new chat
            // It can be new or exists chat in DB
        }
        self.isLoading = false
    }
    
    // if message type is photo. no need using content
    func didChat(type:MessageType, content: String = "", complete: @escaping (Bool) -> Void) {
        
        switch type {
        case .text:
            didChat(message: content, complete: complete)
        case .sticker:
            didChat(sticker: content, complete: complete)
        case .photo:
            didChat(photo: self.photo, complete: complete)
        }
    }
    
    func didChat(message: String, complete: @escaping (Bool) -> Void) {
        let newMessage = Message(
            sender: AppManager.shared.currenUID,
            receiver: chat.partnerID,
            content: message,
            type: .text
        )

        pushToUI(mess: newMessage)

        pushToServer(mess: newMessage, complete: complete)
    }
    
    func didChat(sticker: String, complete: @escaping (Bool) -> Void) {
        let newMessage = Message(
            sender: AppManager.shared.currenUID,
            receiver: chat.partnerID,
            sticker: sticker,
            type: .sticker
        )
        
        pushToUI(mess: newMessage)
        
        pushToServer(mess: newMessage, complete: complete)
    }
    
    func didChat(photo: Data, complete: @escaping (Bool) -> Void) {
        let newMessage = Message(
            sender: AppManager.shared.currenUID,
            receiver: chat.partnerID,
            photo: photo,
            type: .photo
        )
        
        pushToUI(mess: newMessage)
        
        pushToServer(mess: newMessage, complete: complete)
    }
    
    func pushToUI(mess: Message) {
        // update on UI and force scroll to bottom most
        messages.append(mess)
        self.objectWillChange.send()
        self.updateUIIfNeedes?()
    }
    
    func pushToServer(mess: Message, complete: @escaping (Bool) -> Void) {
        // To -Do
        // Call to bussiness layer to call server
        complete(true)
    }
}
