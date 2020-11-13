//
//  ChatItem.swift
//  Interface
//
//  Created by Phucnh on 10/2/20.
//

import SwiftUI

// The item that display as cell in ChatTab
struct ChatCell: View {
    
    @ObservedObject var chat: Chat
    
    @State private var showInchat: Bool = false
    
    @EnvironmentObject var appManager: AppManager
    
    var body: some View {
        ZStack {
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
            
            Button {
                showInchat = true
            } label: {
                
                HStack {
                    CircleImage(image: chat.partnerPhoto, diameter: 45)
                    
                    VStack(alignment: .leading) {
                        Text(chat.partnerName)
                            .robotoBold(size: 16)
                        
                        Text(messageContent(message: chat.lastMessage!))
                            .robotoBold(size: 14)
                            .lineLimit(1)
                            .foregroundColor(.init(hex: 0x6D6D6D))
                    }
                    
                    Spacer()
                    CountTimeText(date: chat.lastMessage!.createDate)
                }
            }
        }
        .padding(.trailing)
        .padding(.vertical, 5)
    }
    
    func messageContent(message: Message) -> String {
        message.content ?? "File đính kèm"
    }
}

struct ChatItem_Previews: PreviewProvider {
    static var previews: some View {
        ChatCell(chat: Chat())
    }
}
