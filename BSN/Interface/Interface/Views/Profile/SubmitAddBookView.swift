//
//  SubmitAddBookView.swift
//  Interface
//
//  Created by Phucnh on 10/11/20.
//

import SwiftUI

struct SubmitAddBookView: View {
    
    @StateObject var viewModel: SubmitAddBookViewModel = SubmitAddBookViewModel()
    
    var body: some View {
        ScrollView {
            VStack {
                VStack(spacing: 10) {
                    MyBookDetailViewHeader(model: viewModel.model)
                        .padding(.top, 10)

                    textInput
                }
                .padding(.horizontal)
                
                Form {
                    Picker("Tình trạng", selection: $viewModel.model.status) {
                        ForEach(BookStatus.allCases, id: \.self) {
                            Text("\($0.getTitle())")
                        }
                    }
                    
                    Picker("Trạng thái", selection: $viewModel.model.state) {
                        ForEach(BookState.allCases, id: \.self) {
                            Text("\($0.getTitle())")
                        }
                    }
                }
                .frame(height: 130)
                
                Button(action: {
                    viewModel.addBook { (success) in
                        print("did save book")
                    }
                }, label: {
                    Text("   Hoàn tất   ")
                })
                .buttonStyle(BaseButtonStyle(size: .largeH))
                .padding(.bottom)
            }
        }
        .background(Color(.secondarySystemBackground))
    }
    
    var textInput: some View {
        VStack {
            InputWithTitle(content: $viewModel.model.name, placeHolder: "Nhập tên sách", title: "Tiêu đề")
            
            InputWithTitle(content: $viewModel.model.author, placeHolder: "Nhập tác giả chính", title: "Tác giả")

            InputWithTitle(content: $viewModel.bookCode, placeHolder: "ex: Nhập mã in sau bìa sách", title: "Mã sách")

            InputWithTitle(content: $viewModel.model.statusDes, placeHolder: "Hãy mô tả càng chi tiết nhất có thể", title: "Mô tả tình trạng sách")
        }
    }
}

struct SubmitAddBookView_Previews: PreviewProvider {
    static var previews: some View {
        SubmitAddBookView()
    }
}
