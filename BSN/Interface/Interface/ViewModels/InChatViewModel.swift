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
    
    // Did send new message
    var didSend: (() -> Void)?
    
    init() {
        messages = [Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message()]
        partner = User()
        isLoading = true
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
    
    func didChat(message: String, complete: @escaping (Bool) -> Void) {
        let newMessage = Message(
            sender: RootViewModel.shared.currentUser,
            receiver: partner,
            content: message,
            type: .text
        )
        
        // update on UI and force scroll to bottom most
        messages.append(newMessage)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.didSend?()
        })
        
        // To -Do
        // Call to bussiness layer to call server
        
        complete(true)
    }
}
