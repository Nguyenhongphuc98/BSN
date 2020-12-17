//
//  ChangePassWordView.swift
//  Interface
//
//  Created by Phucnh on 12/7/20.
//

import SwiftUI

struct ChangePassWordView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var viewModel: ChangePasswordViewModel = .init()
    
    @State private var oldPass: String = ""
    @State private var newPass: String = ""
    @State private var confirmNewPass: String = ""
    
    var body: some View {
        Form {
            Section {
                SecureField("Mật khẩu cũ", text: $oldPass)
                SecureField("Mật khẩu mới (>8 ký tự)", text: $newPass)
                SecureField("Xác nhận mật khẩu", text: $confirmNewPass)
            }
            
            Section {
                Button(action: {
                    viewModel.resetPassword(oldPass: oldPass, newPass: newPass, confirm: confirmNewPass)
                }, label: {
                    HStack {
                        Spacer()
                        Text("Cập nhật")
                        Spacer()
                    }
                })
                .disabled(disableReset)
            }            
        }
        .resignKeyboardOnDragGesture()
        .background(Color(.secondarySystemBackground))
        .navigationTitle(Text("Đổi mật khẩu"))
        .navigationBarBackButtonHidden(true)
        .navigationBarTitle("Đổi mật khẩu")
        .navigationBarHidden(false)
        .navigationBarItems(leading: backButton)
        .alert(isPresented: $viewModel.showAlert, content: alert)
    }
    
    private var backButton: some View {
        Button {
            dismiss()
        } label: {
            BackWardButton()
        }
    }
    
    func alert() -> Alert {
        return Alert(
            title: Text("Thông báo"),
            message: Text(viewModel.message),
            dismissButton: .default(Text("OK")) {
                if viewModel.changeSuccess {
                    dismiss()
                }
            })
    }
    
    var disableReset: Bool {
        oldPass.isEmpty || newPass.count < 8 || confirmNewPass.count < 8
    }
    
    private func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }
}
