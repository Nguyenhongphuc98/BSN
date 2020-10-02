//
//  ChatView.swift
//  Interface
//
//  Created by Phucnh on 10/2/20.
//

import SwiftUI

public struct ChatView: View {
    
    @StateObject var viewModel: ChatViewModel = ChatViewModel()
    
    @EnvironmentObject var root: RootViewModel
    
    public init() {
        
    }
    
    public var body: some View {
        VStack {
            SearchBar(searchText: $viewModel.searchText)
                .padding(.top, 10)
            
            List {
                ForEach(viewModel.chats) { c in
                    ChatItem(message: c)
                }
            }
            .resignKeyboardOnDragGesture()
        }
        .onAppear(perform: viewAppeared)
    }
    
    private var newChatButton: some View {
        Button(action: {
            print("did click add new chat")
        }, label: {
            Image(systemName: "plus.bubble.fill")
                .resizable()
                .frame(width: 25, height: 25)
        })
    }
    
    private func viewAppeared() {
        root.navBarTitle = "Nhắn tin"
        root.navBarTrailingItems = .init(newChatButton)
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
