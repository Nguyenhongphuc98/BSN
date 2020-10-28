//
//  ExchangeListView.swift
//  Interface
//
//  Created by Phucnh on 10/9/20.
//

import SwiftUI

struct ExchangeListView: View {
    
    @StateObject var viewModel: ExchangeListViewModel = ExchangeListViewModel()
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Separator(color: .white, height: 3)
            List {
                ForEach(viewModel.models) { item in
                    ExchangeBookCell(model: item)
                }
            }
        }
        .navigationBarTitle("Danh sách trao đổi", displayMode: .inline)
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

struct ExchangeListView_Previews: PreviewProvider {
    static var previews: some View {
        ExchangeListView()
    }
}
