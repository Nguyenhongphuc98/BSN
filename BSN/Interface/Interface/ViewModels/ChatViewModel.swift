//
//  ChatViewModel.swift
//  Interface
//
//  Created by Phucnh on 10/2/20.
//

import SwiftUI

class ChatViewModel: ObservableObject {
    
    @Published var chats: [Message]
    
    @Published var searchText: String
    
    init() {
        chats = [Message(), Message(), Message(), Message(), Message(), Message(), Message()]
        searchText = ""
    }
}
