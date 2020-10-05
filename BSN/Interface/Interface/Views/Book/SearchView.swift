//
//  SearchView.swift
//  Interface
//
//  Created by Phucnh on 10/5/20.
//

import SwiftUI

public struct SearchView: View {
    
    @StateObject var viewModel: SearchViewViewModel = SearchViewViewModel()
    
    @EnvironmentObject var root: RootViewModel
    
    @State var searchFound: Bool = false
    
    @State private var presentBook: Bool = false
    
    @State private var action: Int? = 0
    
    @State private var selectedSegment: Int = 0
    
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
            
            Segment(tabNames: ["Được yêu thích", "Đang trao đổi"], focusIndex: $selectedSegment)
                .padding(.vertical, 5)
            
            TabView(selection: self.$selectedSegment){
                
                BookGrid(models: viewModel.books)
                    .tag(0)
                
                ExchangeBookList(models: viewModel.exchangeBooks)
                    .tag(1)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))

            
            Spacer()
        }
        .resignKeyboardOnDragGesture()
        .onAppear(perform: viewAppeared)
    }
    
    private func viewAppeared() {
        if root.selectedIndex == RootIndex.explore.rawValue {
            root.navBarTitle = "Khám phá"
            //root.navBarTrailingItems = .init(EmptyView())
            root.navBarHidden = true
        }
        print("search appeard")
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
