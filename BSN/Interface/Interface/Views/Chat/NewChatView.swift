//
//  NewChatView.swift
//  Interface
//
//  Created by Phucnh on 10/3/20.
//

import SwiftUI

struct NewChatView: View {
    
    @StateObject var viewModel: NewChatViewModel = NewChatViewModel()
    
    var didRequestChatTo: ((User) -> Void)?
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            SearchBar(isfocus: $viewModel.isFocus, searchText: $viewModel.searchText, oncancel: {
                dismiss()
            })
            .onReceive(viewModel.$searchText, perform: { text in
                print("did receive text: \(text)")
                viewModel.searchUser()
            })
            .padding(.top, 20)
            
            Group {
                List {
                    ForEach(viewModel.searchedContacts) { u in
                        SearchUserItem(user: u) {
                            didRequestChatTo?(u)
                            dismiss()
                        }
                    }
                }
                
                if viewModel.searchedContacts.isEmpty {
                    Text("Không tìm thấy người dùng")
                        .robotoLightItalic(size: 13)
                        .foregroundColor(.gray)
                        .padding()
                }
            }
            .padding(.top)
            .resignKeyboardOnDragGesture()
            
            Spacer()
        }
    }
    
    private func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }
}

struct NewChatView_Previews: PreviewProvider {
    static var previews: some View {
        NewChatView()
    }
}
