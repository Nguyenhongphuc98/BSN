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
    
    @State private var activeNav: Bool = false {
        didSet {
            print("did set activeNav - SearchAddBookView")
        }
    }
    
    // Mean can't create new book,
    // Search in store only
    var useForExchangeBook: Bool = false
    
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject private var navState: NavigationState
    
    @EnvironmentObject private var pasthoughtObj: PassthroughtEB
    
    public var body: some View {
        VStack {
            SearchBar(isfocus: $viewModel.isfocus, searchText: $viewModel.searchText)
                .padding(.top, 20)
                .onChange(of: viewModel.searchText) { _ in
                    viewModel.searchBook()
                }
            
            searchContent
                .resignKeyboardOnDragGesture()
            
            Spacer()
        }
        .navigationBarItems(leading: backButton)
        .navigationBarBackButtonHidden(true)
    }
    
    private var backButton: some View {
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            Image(systemName: "chevron.backward")
                .foregroundColor(.gray)
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
                                destination: getDestination(id: book.id!)
                                    .environmentObject(navState)
                                    .environmentObject(pasthoughtObj),
                                isActive: $activeNav,
                                label: {
                                    EmptyView()
                                })
                            
                            Button {
                                _ = pasthoughtObj.addBook(book: book)
                                activeNav = true
                            } label: {
                                SearchBookItem(model: book)
                            }
                        }
                    }
                }
                
                if viewModel.searchBooks.isEmpty {
                    Text("Không tìm thấy sách")
                        .robotoLightItalic(size: 13)
                        .foregroundColor(.gray)
                        .padding()
                    
                    if !useForExchangeBook {
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
                    destination: SubmitAddBookView().environmentObject(navState),
                    label: {
                        Text("Nhập thủ công")
                            .robotoBold(size: 18)
                    })
            })
            .buttonStyle(BaseButtonStyle(size: .largeH, type: .secondary))
        }
    }
    
    func getDestination(id: String) -> AnyView {
        useForExchangeBook ? .init(SubmitExchangeBookView()) : .init(SubmitAddBookView(bookID: id))
    }
}

struct SearchAddBookView_Previews: PreviewProvider {
    static var previews: some View {
        SearchAddBookView()
    }
}
