//
//  ResetPass.swift
//  BSN
//
//  Created by Phucnh on 12/19/20.
//

import SwiftUI
import Interface

struct ResetPass: View {
    
    @State var email: String = ""
    
    @StateObject var viewModel: ResetPassViewModel = .init()
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ScrollView {
            VStack(spacing: 40) {
                closeBtn
                
                title
                
                requireFields()
            }
            .padding(.horizontal)
        }
        .background(Color(hex: 0xFCFFFD))
        .embededLoading(isLoading: $viewModel.isLoading)
        .alert(isPresented: $viewModel.showAlert, content: alert)
    }
    
    private var closeBtn: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 35))
            }

            Spacer()
        }
    }
    
    private var title: some View {
        VStack(spacing: 5) {
            Text("Quên mật khẩu")
                .robotoBold(size: 25)
            
            Text("Sử dụng email đã đăng ký và lấy lại mật khẩu")
                .robotoItalic(size: 16)
                .foregroundColor(.init(hex: 0xBDBDBD))
        }
    }
    
    private func requireFields() -> some View {
        VStack(spacing: 15) {
            Text(viewModel.message)
                .foregroundColor(.init(hex: 0x721c24))
            
            TextFieldWithIcon(icon: "person.fill", placer: "youremail@example.com", content: $email, contentType: .emailAddress)
            
            Button(action: {
                viewModel.reset(email: email)
            }, label: {
                Text(" Lấy lại mật khẩu ")
                    .robotoBold(size: 15)
            })
            .buttonStyle(RoundButtonStyle(size: .largeH))
            .padding()
            .disabled(email.isEmpty)
        }
        .padding(.bottom)
        .padding(.horizontal)
    }
    
    private func alert() -> Alert {
        return Alert(
            title: Text("Kết quả"),
            message: Text(viewModel.resourceInfo.des()),
            dismissButton: .default(Text("OK")) {
                dismiss() // reset pass success, back to login
            })
    }
    
    private func dismiss() {
        withAnimation { presentationMode.wrappedValue.dismiss() }
    }
}

struct ResetPass_Previews: PreviewProvider {
    static var previews: some View {
        ResetPass()
    }
}

