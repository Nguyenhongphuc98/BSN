//
//  Login.swift
//  BSN
//
//  Created by Phucnh on 11/11/20.
//

import SwiftUI
import Interface

struct Login: View {
    
    @StateObject var viewModel: LoginViewModel = .init()
    
    @State var username: String = ""
    @State var password: String = ""
    
    @State private var presentSignUp: Bool = false
    @State private var presentfogetPass: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                Spacer()
                VStack {
                    Image("lauchlogo")
                        .resizable()
                        .frame(width: 75, height: 75)
                    
                    Text("Chào mừng đến với SE!")
                        .pattaya(size: 20)
                }
                
                manualLogin()
                
                VStack(spacing: 15) {
                    Text("Hoặc kết nối bằng")
                        .robotoBold(size: 15)
                        .foregroundColor(.init(hex: 0xBDBDBD))
                    
                    Button {
                        viewModel.loginWithFacebook()
                    } label: {
                        Image("fblogo")
                            .resizable()
                            .frame(width: 55, height: 55)
                    }
                    
                    registerText()
                }
                .padding()
            }
            .padding()
        }
        .embededLoading(isLoading: $viewModel.isLoading)
        .alert(isPresented: $viewModel.showAlert, content: alert)
    }
    
    private func manualLogin() -> some View {
        VStack(spacing: 5) {
            Text(viewModel.message)
                .foregroundColor(.init(hex: 0x721c24))
            
            TextFieldWithIcon(icon: "person.fill", placer: "youremail@example.com", content: $username, contentType: .emailAddress)
                .padding(.vertical, 15)
            
            TextFieldWithIcon(icon: "key.fill", placer: "password", content: $password, contentType: .password)
            
            HStack {
                Spacer()
                Button {
                    presentfogetPass.toggle()
                } label: {
                    Text("Quên mật khẩu?")
                        .robotoItalic(size: 13)
                        .foregroundColor(._primary)
                        .padding(.trailing, 20)
                }
                .fullScreenCover(isPresented: $presentfogetPass, content: {
                    ResetPass()
                })
            }
            
            Button(action: {
                viewModel.login(username: username, password: password)
            }, label: {
                Text("   Đăng nhập  ")
                    .robotoBold(size: 15)
            })
            .padding()
            .buttonStyle(RoundButtonStyle(size: .largeH))
            .disabled(disableLogin)
        }
        .padding(.horizontal)
    }
    
    private func registerText() -> some View {
        HStack {
            Text("Không có tài khoản? ")
                .robotoBold(size: 15)
                .foregroundColor(.init(hex: 0x606060))
            +
            Text("Đăng ký")
                .robotoBold(size: 15)
                .foregroundColor(.init(hex: 0x2A66FD))
        }
        .onTapGesture(count: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/, perform: {
            presentSignUp.toggle()
        })
        .fullScreenCover(isPresented: $presentSignUp, content: {
            SignUp()
        })
    }
    
    var disableLogin: Bool {
        username.isEmpty || password.isEmpty
    }
    
    func alert() -> Alert {
        return Alert(
            title: Text("Kết quả"),
            message: Text(viewModel.resourceInfo.des()),
            dismissButton: .default(Text("OK")) {
                
            })
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login()
    }
}

struct TextFieldWithIcon: View {
    
    var icon: String
    
    var placer: String
    
    @Binding var content: String
    
    var contentType: UITextContentType = .name
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 20, height: 20)
            
            if contentType == .password {
                SecureField(placer, text: $content)
            } else {
                TextField(placer, text: $content)
            }
        }
        .padding(10)
        .background(
          RoundedRectangle(cornerRadius: 25)
            .strokeBorder(borderColor, lineWidth: 1)
      )
        .foregroundColor(borderColor)
    }
    
    var borderColor: Color {
        content.isEmpty ? .gray : .blue
    }
}
