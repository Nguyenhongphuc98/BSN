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
    
    var body: some View {
        HStack {
            NavigationLink(destination: Text("detail message").navigationTitle("hehe"), tag: 1, selection: $action) {
                EmptyView()
            }
            .frame(width: 0, height: 0)
            .opacity(0)
            
            CircleImage(image: message.sender.avatar, diameter: 45)
            
            VStack(alignment: .leading) {
                Text(message.sender.displayname)
                    .robotoBold(size: 16)
                
                Text(message.content)
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
}

struct ChatItem_Previews: PreviewProvider {
    static var previews: some View {
        ChatItem(message: Message())
    }
}
