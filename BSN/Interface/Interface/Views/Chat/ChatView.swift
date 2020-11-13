//
//  ChatView.swift
//  Interface
//
//  Created by Phucnh on 10/2/20.
//

import SwiftUI

public struct ChatView: View {
    
    @StateObject var viewModel: ChatViewModel = ChatViewModel()
    
    @EnvironmentObject var root: AppManager
    
    @State var searchFound: Bool = false
    
    @State private var presentNewChat: Bool = false
    
    @State private var action: Int? = 0
    
    public init() {
        
    }
    
    public var body: some View {
        VStack {
            NavigationLink(
                destination: InChatView()
                    .environmentObject(Chat(partner: viewModel.selectedUserNewChat)),
                tag: 1,
                selection: $action) {
                EmptyView()
            }
            .frame(width: 0, height: 0)
            .opacity(0)
            
            SearchBar(isfocus: $viewModel.isfocus, searchText: $viewModel.searchText)
                .padding(.top, 20)
                .onChange(of: viewModel.searchText) { _ in
                    viewModel.searchChat { (success) in
                        print("did search: \(success)")
                        self.searchFound = success
                    }
                }
            
            Group {
                if viewModel.isfocus {
                    if viewModel.isSearching {
                        Loading()
                            .padding(.top, 100)
                    } else {
                        ForEach(viewModel.searchChats) { c in
                            SearchUserItem(
                                user: User(
                                    id: c.partnerID,
                                    displayname: c.partnerName,
                                    avatar: c.partnerPhoto)
                            )
                        }

                        if !searchFound {
                            Text("Không tìm thấy người dùng")
                                .robotoLightItalic(size: 13)
                                .foregroundColor(.gray)
                                .padding()
                        }
                    }
                } else {
                    List {
                        ForEach(viewModel.chats) { c in
                            ChatCell(chat: c)
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .resignKeyboardOnDragGesture()
            
            Spacer()
        }
        .onAppear(perform: viewAppeared)
        .navigationBarHidden(viewModel.isfocus)
        .navigationBarItems(trailing: newChatButton)
    }
    
    private var newChatButton: some View {
        Button(action: {
            print("did click add new chat")
            presentNewChat = true
        }, label: {
            Image(systemName: "plus.bubble.fill")
                .resizable()
                .frame(width: 25, height: 25)
        })
        .sheet(isPresented: $presentNewChat) {
            NewChatView() { user in
                viewModel.selectedUserNewChat = user
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    action = 1
                }
            }
        }
    }
    
    private func viewAppeared() {
        print("chat-apeard")
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
