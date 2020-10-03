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
    
    @State var searchFound: Bool = false
    
    public init() {
        
    }
    
    public var body: some View {
        VStack {
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
                            SearchChatItem(message: c)
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
                            VStack {
                                ChatItem(message: c)
                                Separator(color: .white, height: 2)
                            }
                        }
                    }
                }
            }
            .resignKeyboardOnDragGesture()
            
            Spacer()
        }
        .onAppear(perform: viewAppeared)
        .navigationBarHidden(viewModel.isfocus)
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
        root.navBarHidden = viewModel.isfocus
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
