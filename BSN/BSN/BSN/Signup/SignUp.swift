//
//  SignUp.swift
//  BSN
//
//  Created by Phucnh on 12/5/20.
//

import SwiftUI
import Interface

struct SignUp: View {
    
    @State var displayname: String = ""
    
    @State var username: String = "" // email
    
    @State var password: String = ""
    
    @State var confirmPassword: String = ""
    
    @StateObject var viewModel: SignUpViewModel = SignUpViewModel()
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ScrollView {
            VStack(spacing: 40) {
                closeBtn
                
                title
                
                requireFields()
                
                loginText()
                
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
            Text("Tạo tài khoản mới")
                .robotoBold(size: 25)
            
            Text("Tạo tài khoản để kết nối vời những người yêu sách")
                .robotoItalic(size: 15)
                .foregroundColor(.init(hex: 0xBDBDBD))
        }
    }
    
    private func requireFields() -> some View {
        VStack(spacing: 15) {
            Text(viewModel.message)
                .foregroundColor(.init(hex: 0x721c24))
            
            TextFieldWithIcon(icon: "person.crop.circle", placer: "displayname", content: $displayname, contentType: .emailAddress)
            
            TextFieldWithIcon(icon: "person.fill", placer: "youremail@example.com", content: $username, contentType: .emailAddress)
            
            TextFieldWithIcon(icon: "key.fill", placer: "password (>= 8 character)", content: $password, contentType: .password)
            
            TextFieldWithIcon(icon: "key.fill", placer: "confirm password", content: $confirmPassword, contentType: .password)
            
            Button(action: {
                viewModel.signup(displayname: displayname, username: username, password: password, confirmPass: confirmPassword)
            }, label: {
                Text("       Đăng ký       ")
                    .robotoBold(size: 15)
            })
            .buttonStyle(RoundButtonStyle(size: .largeH))
            .padding()
            .disabled(disableRegister)
        }
        .padding(.bottom)
        .padding(.horizontal)
    }
    
    private func loginText() -> some View {
        HStack {
            Text("Đã có tài khoản? ")
                .robotoBold(size: 15)
                .foregroundColor(.init(hex: 0x606060))
            +
            Text("Đăng nhập")
                .robotoBold(size: 15)
                .foregroundColor(.init(hex: 0x2A66FD))
        }
        .onTapGesture(count: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/, perform: {
            dismiss()
        })
    }
    
    private var disableRegister: Bool {
        confirmPassword.isEmpty || password.isEmpty || username.isEmpty
    }
    
    private func alert() -> Alert {
        return Alert(
            title: Text("Kết quả"),
            message: Text(viewModel.resourceInfo.des()),
            dismissButton: .default(Text("OK")) {
                dismiss() // success, back to login
            })
    }
    
    private func dismiss() {
        withAnimation { presentationMode.wrappedValue.dismiss() }
    }
}

struct SignUp_Previews: PreviewProvider {
    static var previews: some View {
        SignUp()
    }
}
