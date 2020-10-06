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
    
    var body: some View {
        VStack {
            Separator(color: .white, height: 3)
            List {
                ForEach(viewModel.models) { item in
                    BorrowBookCard(model: item)
                }
            }
        }
        .navigationBarTitle("Danh sách cho mượn", displayMode: .inline)
        .navigationBarHidden(false)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
    }
    
    var backButton: some View {
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            Image(systemName: "chevron.backward")
                .foregroundColor(.gray)
        }
    }
}

struct BorrowListView_Previews: PreviewProvider {
    static var previews: some View {
        BorrowListView()
    }
}
