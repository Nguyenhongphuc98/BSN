//
//  SearchAddBookView.swift
//  Interface
//
//  Created by Phucnh on 10/11/20.
//

import SwiftUI

struct SearchAddBookView: View {
    
    @StateObject var viewModel: SearchBookViewModel = SearchBookViewModel()
    
    @State private var searchFound: Bool = false
    
    public init() {
        
    }
    
    public var body: some View {
        VStack {
            SearchBar(isfocus: $viewModel.isfocus, searchText: $viewModel.searchText)
                .padding(.top, 20)
                .onChange(of: viewModel.searchText) { _ in
                    viewModel.searchBook { (success) in
                        print("did search: \(success)")
                        self.searchFound = success
                    }
                }
            
            viewSearchMode
                .resignKeyboardOnDragGesture()
            
            Spacer()
        }
    }
    
    private var viewSearchMode: some View {
        Group {
            if viewModel.isSearching {
                Loading()
                    .padding(.top, 100)
            } else {
                ScrollView {
                    LazyVStack {
                        ForEach(viewModel.searchBooks) { book in
                            NavigationLink(
                                destination: BookDetailView(),
                                label: {
                                    SearchBookCard(model: book)
                                })
                            
                                .padding(.horizontal)
                        }
                    }
                }
                
                if !searchFound {
                    Text("Không tìm thấy sách")
                        .robotoLightItalic(size: 13)
                        .foregroundColor(.gray)
                        .padding()
                    
                    VStack {
                        Spacer()
                        
                        Button(action: {
                            
                        }, label: {
                            Text("Nhập thủ công")
                                .robotoBold(size: 18)
                        })
                        .buttonStyle(BaseButtonStyle(size: .largeH, type: .secondary))
                    }
                }
            }
        }
    }
}

struct SearchAddBookView_Previews: PreviewProvider {
    static var previews: some View {
        SearchAddBookView()
    }
}
