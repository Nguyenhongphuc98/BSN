//
//  ChatItem.swift
//  Interface
//
//  Created by Phucnh on 10/2/20.
//

import SwiftUI

// The item that display as cell in ChatTab
struct ChatItem: View {
    
    @ObservedObject var message: Message
    
    @State private var action: Int? = 0
    
    @EnvironmentObject var root: RootViewModel
    
    var body: some View {
        HStack {
            NavigationLink(
                destination: InChatView().environmentObject(message.sender).environmentObject(root),
                tag: 1,
                selection: $action
            ) {
                EmptyView()
            }
            .frame(width: 0, height: 0)
            .opacity(0)
            
            CircleImage(image: message.sender.avatar, diameter: 45)
            
            VStack(alignment: .leading) {
                Text(message.sender.displayname)
                    .robotoBold(size: 16)
                
                Text(messageContent(message: message))
                    .robotoBold(size: 14)
                    .lineLimit(1)
                    .foregroundColor(.init(hex: 0x6D6D6D))
            }
            
            Spacer()
            CountTimeText(date: message.createDate)
        }
        .padding(.trailing)
        .padding(.vertical, 5)
        .onTapGesture {
            action = 1
        }
    }
    
    func messageContent(message: Message) -> String {
        message.content ?? "File đính kèm"
    }
}

struct ChatItem_Previews: PreviewProvider {
    static var previews: some View {
        ChatItem(message: Message())
    }
}
