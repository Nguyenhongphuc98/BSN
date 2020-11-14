//
//  InChatViewModel.swift
//  Interface
//
//  Created by Phucnh on 10/2/20.
//

import SwiftUI
import Business

class InChatViewModel: NetworkViewModel {
    
    @Published var messages: [Message]
    
    @Published var chat: Chat
    
    // Photo to send if select from gallery
    @Published var photo: Data
    
    private var messageManager: MessageManager
    
    // Did send new message
    // It's content should be force UI scroll to bottom
    var updateUIIfNeedes: (() -> Void)?
    
    override init() {
        messages = []
        chat = Chat()
        photo = Data()
        messageManager = MessageManager()
        
        super.init()
        observerSaveMessage()
    }
    
    func fetchData(chat: Chat) {
        //self.isLoading = true
        self.chat = chat
        
        if self.chat.id != kUndefine {
            // fetch message of this chat
        } else {
            // Get chat info by curren user and parter user
            // It called usualy because user search new chat
            // It can be new or exists chat in DB
            // then fetch message of this chat if exists
        }
    }
    
    // if message type is photo. no need using content
    func didChat(type:MessageType, content: String = "") {
        
        switch type {
        case .text:
            didChat(message: content)
        case .sticker:
            didChat(sticker: content)
        case .photo:
            didChat(photo: self.photo)
        }
    }
    
    func didChat(message: String) {
        let newMessage = Message(
            sender: AppManager.shared.currenUID,
            receiver: chat.partnerID,
            content: message,
            type: .text
        )

        pushToUI(mess: newMessage)

        pushToServer(mess: newMessage)
    }
    
    func didChat(sticker: String) {
        let newMessage = Message(
            sender: AppManager.shared.currenUID,
            receiver: chat.partnerID,
            sticker: sticker,
            type: .sticker
        )
        
        pushToUI(mess: newMessage)
        
        pushToServer(mess: newMessage)
    }
    
    func didChat(photo: Data) {
        let newMessage = Message(
            sender: AppManager.shared.currenUID,
            receiver: chat.partnerID,
            photo: photo,
            type: .photo
        )
        
        pushToUI(mess: newMessage)
        
        pushToServer(mess: newMessage)
    }
    
    func pushToUI(mess: Message) {
        // update on UI and force scroll to bottom most
        messages.append(mess)
        self.objectWillChange.send()
        self.updateUIIfNeedes?()
    }
    
    func pushToServer(mess: Message) {
        // To -Do
        // Call to bussiness layer to call server
        let newMessage = EMessage(
            chatID: chat.id,
            senderID: AppManager.shared.currenUID,
            typeName: mess.type.rawValue,
            content: mess.content!,
            receiverID: chat.partnerID
        )
        
        messageManager.saveMess(message: newMessage)
    }
    
    private func observerSaveMessage() {
        messageManager
            .saveMessPublisher
            .sink {[weak self] (mess) in
                
                guard let self = self else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.isLoading = false
                    
                    if mess.id == kUndefine {
                        self.resourceInfo = .savefailure
                        self.showAlert = true
                    } else {
                        
                        self.resourceInfo = .success
                    }
                    
                }
            }
            .store(in: &cancellables)
    }
}
