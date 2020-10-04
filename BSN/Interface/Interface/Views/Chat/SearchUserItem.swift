//
//  SearchChatItem.swift
//  Interface
//
//  Created by Phucnh on 10/3/20.
//

import SwiftUI

struct SearchUserItem: View {
    
    @EnvironmentObject var root: RootViewModel
    
    @ObservedObject var user: User
    
    @State private var action: Int? = 0
    
    var didTap: (() -> Void)?
    
    var body: some View {
        HStack {
            NavigationLink(
                destination: InChatView().environmentObject(user).environmentObject(root),
                tag: 1,
                selection: $action
            ) {
                EmptyView()
            }
            .frame(width: 0, height: 0)
            .opacity(0)
            
            CircleImage(image: user.avatar, diameter: 45)
            
            Text(user.displayname)
                .robotoBold(size: 16)
            
            Spacer()
        }
        .padding(.horizontal)
        .onTapGesture {
            action = 1
            didTap?()
        }
    }
}

struct SearchChatItem_Previews: PreviewProvider {
    static var previews: some View {
        SearchUserItem(user: User())
    }
}
