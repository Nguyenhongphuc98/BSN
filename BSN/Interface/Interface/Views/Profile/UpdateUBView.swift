//
//  UpdateBookView.swift
//  Interface
//
//  Created by Phucnh on 10/11/20.
//

import SwiftUI

struct UpdateUBView: View {
    
    @StateObject var viewModel: UpdateUBViewModel = UpdateUBViewModel()
    
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var model: BUserBook
    
    @State private var firstimeState: Bool = true
    
    @State private var firstimeStatus: Bool = true
    
    var body: some View {
        VStack(spacing: 10) {
            MyBookDetailViewHeader(model: model, showDes: false)
                .padding(.vertical, 10)
                .frame(height: 120)
                .padding(.horizontal)
            
            Form {
                Picker("Tình trạng", selection: $viewModel.bStatus) {
                    ForEach(BookStatus.allCases, id: \.self) {
                        Text("\($0.des())")
                    }
                }
                .onReceive(viewModel.$bStatus) { (status) in
                    if firstimeStatus {
                        firstimeStatus = false
                        viewModel.bStatus = model.status!
                    } else {
                        model.status = status
                    }
                }
                
                Picker("Trạng thái", selection: $viewModel.bState) {
                    ForEach(BookState.allCases, id: \.self) {
                        Text("\($0.des())")
                    }
                }
                .onReceive(viewModel.$bState) { (state) in
                    if firstimeState {
                        firstimeState = false
                        viewModel.bState = model.state!
                    } else {
                        model.state = state
                    }
                }
            }
            .frame(height: 130)
            
            textInput
                .padding(.horizontal)
            
            Spacer()
            Button(action: {
                viewModel.update(model: model)
            }, label: {
                Text("   Cập nhật   ")
            })
            .buttonStyle(BaseButtonStyle(size: .largeH))
            Spacer()
        }
        .padding(.bottom, 100)
        .background(Color(.secondarySystemBackground))
        .embededLoading(isLoading: $viewModel.isLoading)
        //.resignKeyboardOnDragGesture()
        .alert(isPresented: $viewModel.showAlert, content: alert)
    }
    
    func alert() -> Alert {
        if viewModel.resourceInfo == .success {
            return Alert(
                title: Text("Kết quả"),
                message: Text(viewModel.resourceInfo.des()),
                dismissButton: .default(Text("OK")) {
                    dissmiss()
                })
        } else {
            
            return Alert(
                title: Text("Kết quả"),
                message: Text(viewModel.resourceInfo.des()),
                primaryButton: .default(Text("Thử lại")) {
                    viewModel.update(model: model)
                },
                secondaryButton: .cancel(Text("Huỷ bỏ")) {
                    dissmiss()
                })
        }
    }
    
    var textInput: some View {
        InputWithTitle(content: $model.statusDes, placeHolder: "Hãy mô tả càng chi tiết nhất có thể", title: "Mô tả tình trạng sách")
    }
    
    private func dissmiss() {
        presentationMode.wrappedValue.dismiss()
    }
}

struct UpdateBookView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateUBView().environmentObject(BUserBook())
    }
}
