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
    
    @State private var activeNav: Bool = false
    
    // Mean can't create new book,
    // Search in store only
    var useForExchangeBook: Bool = false
    
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject private var navState: NavigationState
    
    @EnvironmentObject private var pasthoughtObj: PassthroughtEB
    
    @State var searchText: String = ""
    
    @State var destinationID: String = "undefine"
    
    public var body: some View {
        VStack {
            SearchBar(isfocus: $viewModel.isfocus, searchText: $searchText)
                .padding(.top, 20)
                .onChange(of: searchText) { _ in
                    viewModel.searchBook(text: searchText)
                }
            
            searchContent
            
            Spacer()
        }
        .navigationBarItems(leading: backButton)
        .navigationBarBackButtonHidden(true)
    }
    
    private var backButton: some View {
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            BackWardButton()
        }
    }
    
    private var searchContent: some View {
        Group {
            if viewModel.isLoading {
                Loading()
                    .padding(.top, 100)
            } else {
               
                    NavigationLink(
                        destination:
                            getDestination(id: destinationID)
                            .environmentObject(navState)
                            .environmentObject(pasthoughtObj),
                        isActive: $activeNav,
                        label: {
                            EmptyView()
                        })
                        .frame(width: 0, height: 0)
                        .opacity(0)
            
                List {
                    ForEach(viewModel.searchBooks) { book in
                        
                        VStack {
                            Button {
                                // exchange
                                _ = pasthoughtObj.addBook(book: book)
                                // add book
                                destinationID = book.id!
                                activeNav = true
                            } label: {
                                SearchBookItem(model: book)
                            }
                            
                            Separator(color: .white, height: 2)
                        }
                    }
                    .listRowInsets(.zeroNegativeTop)
                }
                .padding(.horizontal)
                .padding(.top, 20)
                .resignKeyboardOnDragGesture()
                
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
                    destination: SubmitAddBookView()
                        .environmentObject(navState),
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
