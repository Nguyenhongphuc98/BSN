//
//  SearchView.swift
//  Interface
//
//  Created by Phucnh on 10/5/20.
//

import SwiftUI

public struct ExploreBookView: View {
    
    @StateObject var viewModel: ExploreBookViewModel = ExploreBookViewModel()
    
    @EnvironmentObject var root: AppManager
    
    @State private var presentBook: Bool = false
    
    @State private var action: Int? = 0
    
    @State private var selectedSegment: Int = 0
    
    @State private var searchFound: Bool = false
    
    public init() {
        
    }
    
    public var body: some View {
        VStack {
            SearchBar(isfocus: $viewModel.isfocus, searchText: $viewModel.searchText)
                .padding(.top, 20)
                .onChange(of: viewModel.searchText) { _ in
                    viewModel.searchBook()
                }
            
                if viewModel.isfocus {
                    viewSearchMode
                        .resignKeyboardOnDragGesture()
                } else {
                    viewNormalMode
                }
            
            Spacer()
        }
        .onAppear(perform: viewAppeared)
    }
    
    private var viewNormalMode: some View {
        VStack {
            Segment(tabNames: ["Được yêu thích", "Đang trao đổi"], focusIndex: $selectedSegment)
                .padding(.vertical, 5)
            
            TabView(selection: self.$selectedSegment){
                
//                BookGrid(models: viewModel.books)
//                    .tag(0)
                BBookGrid(models: viewModel.suggestBooks, style: .suggestbook)
                
                ExchangeBookList(models: viewModel.exchangeBooks)
                    .tag(1)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        }
    }
    
    private var viewSearchMode: some View {
        Group {
            if viewModel.isSearching {
                Loading()
                    .padding(.top, 100)
            } else {
                ForEach(viewModel.searchBooks) { book in
                    NavigationLink(
                        destination: BookDetailView(),
                        label: {
                            SearchBookItem(model: book)
                        })
                        .padding(.horizontal)
                }
                
                if viewModel.searchBooks.isEmpty {
                    Text("Không tìm thấy sách")
                        .robotoLightItalic(size: 13)
                        .foregroundColor(.gray)
                        .padding()
                }
            }
        }
    }
    
    private func viewAppeared() {
        print("search appeard")
        viewModel.prepareData()
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreBookView()
    }
}
