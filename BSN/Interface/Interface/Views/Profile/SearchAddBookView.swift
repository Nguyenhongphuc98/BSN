//
//  SearchAddBookView.swift
//  Interface
//
//  Created by Phucnh on 10/11/20.
//

import SwiftUI

// Search any book exists on Book 'Store'
// Use in search to add book
// Use in search to find book exchange
struct SearchAddBookView: View {
    
    @StateObject var viewModel: SearchBookViewModel = SearchBookViewModel()
    
    @State private var searchFound: Bool = false
    
    // Mean can't create new book, search only
    var justSearchInStore: Bool = false
    
//    public init() {
//        
//    }
    
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
            
            searchContent
                .resignKeyboardOnDragGesture()
            
            Spacer()
        }
    }
    
    private var searchContent: some View {
        Group {
            if viewModel.isSearching {
                Loading()
                    .padding(.top, 100)
            } else {
                ScrollView {
                    LazyVStack {
                        ForEach(viewModel.searchBooks) { book in
                            NavigationLink(
                                destination: getDestination(id: book.id),
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
                    
                    if !justSearchInStore {
                        addManually
                    }
                }
            }
        }
    }
    
    var addManually: some View {
        VStack {
            Spacer()
            
            Button(action: {
                
            }, label: {
                NavigationLink(
                    destination: SubmitAddBookView(),
                    label: {
                        Text("Nhập thủ công")
                            .robotoBold(size: 18)
                    })
            })
            .buttonStyle(BaseButtonStyle(size: .largeH, type: .secondary))
        }
    }
    
    func getDestination(id: String) -> AnyView {
        justSearchInStore ? .init(SubmitAddBookView()) : .init(SubmitAddBookView())
    }
}

struct SearchAddBookView_Previews: PreviewProvider {
    static var previews: some View {
        SearchAddBookView()
    }
}
