//
//  SubmitAddBookView.swift
//  Interface
//
//  Created by Phucnh on 10/11/20.
//

import SwiftUI

struct SubmitAddBookView: View {
    
    @EnvironmentObject var navState: NavigationState
    
    // Book will add to User book
    // If create new so it will be nil
    var bookID: String?
    
    @StateObject var viewModel: SubmitAddUBViewModel = SubmitAddUBViewModel()
    
    init(bookID: String? = nil) {
        self.bookID = bookID
    }
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    VStack(spacing: 10) {
                        
                        // Mean shoud get book from google
                        if bookID == nil {
                            isbnInfo
                            
                            Separator(height: 2)
                        }
                        
                        MyBookDetailViewHeader(model: viewModel.model)
                            .padding(.top, 10)

                        InputWithTitle(content: $viewModel.model.statusDes, placeHolder: "Hãy mô tả càng chi tiết nhất có thể", title: "Mô tả tình trạng sách")
                    }
                    .padding(.horizontal)
                    
                    Form {
                        Picker("Tình trạng", selection: $viewModel.bStatus) {
                            ForEach(BookStatus.allCases, id: \.self) {
                                Text("\($0.des())")
                                    .tag($0)
                            }
                        }
                        .onReceive(viewModel.$bStatus) { (status) in
                            viewModel.model.status = status
                        }
                        
                        Picker("Trạng thái", selection: $viewModel.bState) {
                            ForEach(BookState.allCases, id: \.self) {
                                Text("\($0.des())")
                            }
                        }
                        .onReceive(viewModel.$bState) { (state) in
                            viewModel.model.state = state
                        }
                    }
                    .frame(height: 130)
                    
                    Button(action: {
                        viewModel.addUserBook()
                    }, label: {
                        Text("   Hoàn tất   ")
                    })
                    .buttonStyle(BaseButtonStyle(size: .largeH))
                    .disabled(!viewModel.enableDoneBtn)
                    .padding()
                    .padding(.bottom, 40)
                    
                }
            }
            .background(Color(.secondarySystemBackground))
            .resignKeyboardOnDragGesture()
            
            if viewModel.isLoading {
                Loading()
            }
        }
        .onAppear(perform: viewAppeared)
        .alert(isPresented: $viewModel.showAlert, content: alert)
    }
    
    private var isbnInfo: some View {
        HStack {
            InputWithTitle(content: $viewModel.isbn, placeHolder: "Nhập mã in sau bìa sách", title: "Mã ISBN", keyboardType: .numberPad)
            
            VStack {
                Spacer()
                Button(action: {
                    viewModel.loadInfoFromGoogle()
                }, label: {
                    Text("Truy vấn")
                        .padding(.vertical, 3)
                })
                .buttonStyle(BaseButtonStyle(size: .medium, type: .primary))
            }
            .frame(height: 70)
        }
    }
    
    func alert() -> Alert {
        if viewModel.resourceInfo == .success {
            return Alert(
                title: Text("Kết quả"),
                message: Text(viewModel.resourceInfo.des()),
                dismissButton: .default(Text("OK")) {
                    popToRoot()
                })
        } else {
            
            return Alert(
                title: Text("Kết quả"),
                message: Text(viewModel.resourceInfo.des()),
                primaryButton: .default(Text("Thử lại")) {
                    viewModel.addUserBook()
                },
                secondaryButton: .cancel(Text("Huỷ bỏ")) {
                    popToRoot()
                })
        }
    }
    
    private func viewAppeared() {
        if let id = bookID {
            viewModel.prepareData(bookID: id)
        }
    }
    
    private func popToRoot() {
        navState.popTo(viewName: .profileRoot)
    }
}

struct SubmitAddBookView_Previews: PreviewProvider {
    static var previews: some View {
        SubmitAddBookView(bookID: "12345")
    }
}
