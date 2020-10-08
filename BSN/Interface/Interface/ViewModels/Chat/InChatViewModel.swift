//
//  InChatViewModel.swift
//  Interface
//
//  Created by Phucnh on 10/2/20.
//

import SwiftUI

class InChatViewModel: ObservableObject {
    
    @Published var messages: [Message]
    
    @Published var partner: User
    
    @Published var isLoading: Bool
    
    @Published var photo: Data
    
    // Did send new message
    // It's content should be force UI scroll to bottom
    var updateUIIfNeedes: (() -> Void)?
    
    init() {
        messages = [Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message()]
        partner = User()
        isLoading = true
        photo = Data()
        partner.displayname = "..."
    }
    
    func fetchData(partner: User) {
        self.isLoading = true
        self.partner = partner
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            withAnimation {
                self.isLoading = false
            }
        }
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
            sender: AppManager.shared.currentUser,
            receiver: partner,
            content: message,
            type: .text
        )

        pushToUI(mess: newMessage)

        pushToServer(mess: newMessage, complete: complete)
    }
    
    func didChat(sticker: String, complete: @escaping (Bool) -> Void) {
        let newMessage = Message(
            sender: AppManager.shared.currentUser,
            receiver: partner,
            sticker: sticker,
            type: .sticker
        )
        
        pushToUI(mess: newMessage)
        
        pushToServer(mess: newMessage, complete: complete)
    }
    
    func didChat(photo: Data, complete: @escaping (Bool) -> Void) {
        let newMessage = Message(
            sender: AppManager.shared.currentUser,
            receiver: partner,
            photo: photo,
            type: .photo
        )
        
        pushToUI(mess: newMessage)
        
        pushToServer(mess: newMessage, complete: complete)
    }
    
    func pushToUI(mess: Message) {
        // update on UI and force scroll to bottom most
        messages.append(mess)
        self.updateUIIfNeedes?()
    }
    
    func pushToServer(mess: Message, complete: @escaping (Bool) -> Void) {
        // To -Do
        // Call to bussiness layer to call server
        complete(true)
    }
}
