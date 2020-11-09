//
//  BorrowListView.swift
//  Interface
//
//  Created by Phucnh on 10/6/20.
//

import SwiftUI

struct BorrowListView: View {
    
    @StateObject var viewModel: BorrowListViewModel = BorrowListViewModel()
    
    @Environment(\.presentationMode) var presentationMode
    
    var bid: String
    
    var body: some View {
        VStack {
            Separator(color: .white, height: 3)
            List {
                ForEach(viewModel.models) { item in
                    BorrowBookCell(model: item)
                }
            }
            if viewModel.models.isEmpty {
                Text("Sách này không có sẵn để mượn")
                    .font(.system(.title3))
                    .italic()
                    
                Spacer(minLength: 300)
            }
        }
        .embededLoading(isLoading: $viewModel.isLoading)
        .navigationBarTitle("Danh sách cho mượn", displayMode: .inline)
        .navigationBarHidden(false)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
        .onAppear(perform: viewAppeared)
    }
    
    var backButton: some View {
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            Image(systemName: "chevron.backward")
                .foregroundColor(.gray)
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
