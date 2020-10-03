//
//  SearchChatItem.swift
//  Interface
//
//  Created by Phucnh on 10/3/20.
//

import SwiftUI

struct SearchChatItem: View {
    
    @ObservedObject var message: Message
    
    @State private var action: Int? = 0
    
    var body: some View {
        HStack {
            NavigationLink(destination: InChatView().environmentObject(message.sender), tag: 1, selection: $action) {
                EmptyView()
            }
            .frame(width: 0, height: 0)
            .opacity(0)
            
            CircleImage(image: message.sender.avatar, diameter: 45)
            
            Text(message.sender.displayname)
                .robotoBold(size: 16)
            
            Spacer()
        }
        .padding(.horizontal)
        .onTapGesture {
            action = 1
        }
    }
}

struct SearchChatItem_Previews: PreviewProvider {
    static var previews: some View {
        SearchChatItem(message: Message())
    }
}
