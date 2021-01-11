//
//  ExchangeListView.swift
//  Interface
//
//  Created by Phucnh on 10/9/20.
//

import SwiftUI

// List available exhange for special book
struct ExchangeListView: View {
    
    @StateObject var viewModel: ExchangeListViewModel = .init()
    
    @Environment(\.presentationMode) var presentationMode
    
    var bid: String
    
    var body: some View {
        VStack {
            if viewModel.models.isEmpty {
                Text("Không có sẵn sách trao đổi cho cuốn sách này")
                    .robotoLightItalic(size: 13)
                    .padding()
            }
            
            Separator(color: .white, height: 3)
            
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.models) { item in
                        ExchangeBookCell(model: item)
                    }
                }
            }
        }
        .embededLoadingFull(isLoading: $viewModel.isLoading)
        .navigationBarTitle("Danh sách trao đổi", displayMode: .inline)
        .navigationBarHidden(false)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
        .onAppear(perform: viewAppeared)
    }
    
    var backButton: some View {
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            BackWardButton()
        }
    }
    
    func viewAppeared() {
        viewModel.prepareData(bid: bid)
    }
}

struct ExchangeListView_Previews: PreviewProvider {
    static var previews: some View {
        ExchangeListView(bid: "")
    }
}
