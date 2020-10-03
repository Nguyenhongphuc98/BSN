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
            SearchBar(isfocus: $viewModel.isFocus, searchText: $viewModel.searchText)
                .padding(.top, 20)
                .onChange(of: viewModel.searchText) { _ in
                    viewModel.searchChat { (success) in
                        print("did search: \(success)")
                    }
                }
            
            Group {
                List {
                    ForEach(viewModel.displayContacts) { u in
                        SearchUserItem(user: u) {
                            didRequestChatTo?(u)
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
                
                if viewModel.displayContacts.isEmpty {
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
}

struct NewChatView_Previews: PreviewProvider {
    static var previews: some View {
        NewChatView()
    }
}
