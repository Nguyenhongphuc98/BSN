//
//  ChatItem.swift
//  Interface
//
//  Created by Phucnh on 10/2/20.
//

import SwiftUI
import Business

// The item that display as cell in ChatTab
struct ChatCell: View {
    
    @ObservedObject var chat: Chat
    
    @State private var showInchat: Bool = false
    
    @EnvironmentObject var appManager: AppManager
    
    var chatManager: ChatManager = .sharedUpdate
    
    var body: some View {
        ZStack {
            navToInChat
            
            Button {
                handleDidClick()
            } label: {
                
                HStack {
                    CircleImage(image: chat.partnerPhoto, diameter: 45)
                    
                    VStack(alignment: .leading) {
                        Text(chat.partnerName)
                            .robotoBold(size: 16)
                        
                        Text(messageContent(message: chat.lastMessage!))
                            .robotoBold(size: 14)
                            .lineLimit(1)
                            .foregroundColor(messageColor)
                    }
                    
                    Spacer()
                    CountTimeText(date: chat.lastMessage!.createDate)
                }
            }
        }
        .padding(.trailing)
        .padding(.vertical, 5)
    }
    
    private var navToInChat: some View {
        NavigationLink(
            destination: InChatView()
                .environmentObject(chat)
                .environmentObject(appManager),
            isActive: $showInchat
        ) {
            EmptyView()
        }
        .frame(width: 0, height: 0)
        .opacity(0)
    }
    
    private var messageColor: Color {
        chat.seen ? .init(hex: 0x6D6D6D) : .black
    }
    
    private func messageContent(message: Message) -> String {
        switch message.type {
        case .text:
            return message.content!
        case .sticker:
            return "[Sticker]"
        case .photo:
            return "[Photo]"
        }
    }
    
    private func handleDidClick() {
        showInchat = true
        chat.seen = true
        let updatechat = EChat(id: chat.id!, seen: chat.seen)
        chatManager.updateChat(chat: updatechat)
    }
}

struct ChatItem_Previews: PreviewProvider {
    static var previews: some View {
        ChatCell(chat: Chat())
    }
}
