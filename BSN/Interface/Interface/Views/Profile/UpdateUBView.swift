//
//  UpdateBookView.swift
//  Interface
//
//  Created by Phucnh on 10/11/20.
//

import SwiftUI

struct UpdateUBView: View {
    
    @StateObject var viewModel: SubmitAddUBViewModel = SubmitAddUBViewModel()
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(spacing: 10) {
            MyBookDetailViewHeader(model: viewModel.model, showDes: false)
                .padding(.vertical, 10)
                .frame(height: 120)
                .padding(.horizontal)
            
            Form {
                Picker("Tình trạng", selection: $viewModel.model.status) {
                    ForEach(BookStatus.allCases, id: \.self) {
                        Text("\($0.getTitle())")
                    }
                }
                
                Picker("Trạng thái", selection: $viewModel.model.state) {
                    ForEach(BookState.allCases, id: \.self) {
                        Text("\($0.des())")
                    }
                }
            }
            .frame(height: 130)
            
            textInput
                .padding(.horizontal)
            
            Spacer()
            Button(action: {
//                viewModel.updateUserBook { (success) in
//                    print("did update book")
//                }
                
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("   Hoàn tất   ")
            })
            .buttonStyle(BaseButtonStyle(size: .largeH))
            Spacer()
        }
        .padding(.bottom)
        .background(Color(.secondarySystemBackground))
    }
    
    var textInput: some View {
        InputWithTitle(content: $viewModel.model.statusDes, placeHolder: "Hãy mô tả càng chi tiết nhất có thể", title: "Mô tả tình trạng sách")
    }
}

struct UpdateBookView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateUBView()
    }
}
