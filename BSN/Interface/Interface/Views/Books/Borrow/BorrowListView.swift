//
//  BorrowListView.swift
//  Interface
//
//  Created by Phucnh on 10/6/20.
//

import SwiftUI

struct BorrowListView: View, PopToable {
    
    var viewName: ViewName = .bookDetail
    
    @EnvironmentObject var navState: NavigationState
    
    @StateObject var viewModel: BorrowListViewModel = BorrowListViewModel()
    
    @Environment(\.presentationMode) var presentationMode
    
    var bid: String
    
    var body: some View {
        VStack {
            if viewModel.models.isEmpty {
                Text("Sách này không có sẵn để mượn")
                    .robotoLightItalic(size: 13)
                    .padding()
            }
            
            Separator(color: .white, height: 3)
            
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.models) { item in
                        BorrowBookCell(model: item)
                            .environmentObject(navState)
                    }                    
                }
            }
        }
        .embededLoadingFull(isLoading: $viewModel.isLoading)
        .navigationBarTitle("Danh sách cho mượn", displayMode: .inline)
        .navigationBarHidden(false)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
        .onAppear(perform: viewAppeared)
        .onReceive(navState.$viewName) { (viewName) in
            if viewName == self.viewName {
                navState.viewName = .undefine
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
    
    var backButton: some View {
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            BackWardButton()
        }
    }
    
    private func viewAppeared() {
        viewModel.prepareData(bid: bid)
    }
}

struct BorrowListView_Previews: PreviewProvider {
    static var previews: some View {
        BorrowListView(bid: "---")
    }
}
