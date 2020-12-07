//
//  SettingView.swift
//  Interface
//
//  Created by Phucnh on 11/12/20.
//

import SwiftUI

struct SettingView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var appManager: AppManager = AppManager.shared
    
    @StateObject var viewModel: SettingViewModel = SettingViewModel()
    
    @State private var showAlertLogout: Bool = false
    
    var body: some View {
        Form {
            Section {
                HStack {
                    CircleImageOptions(image: appManager.currentUser.avatar, diameter: 50)
                        .padding()
                    
                    VStack(alignment: .leading) {
                        Text(appManager.currentUser.displayname).pattaya(size: 18)
                        if appManager.currentUser.about != "" {
                            Text(appManager.currentUser.about).robotoLightItalic(size: 13)
                        }
                    }
                }
            }
            
            Section {
                TextField("Nhập tên mới", text: $appManager.currentUser.displayname)
                TextField("Thêm mô tả", text: $appManager.currentUser.about)
                
                
                Button(action: {
                    print("did click update")
                }, label: {
                    HStack {
                        Spacer()
                        Text("Cập nhật")
                        Spacer()
                    }
                })
            }
            
            Section {
                NavigationLink(destination: PersonalizeView(onboard: false)) {
                    TextWithIcon(icon: "heart.fill", text: "Thể loại yêu thích", foreground: 0xff00bb)
                }
                
                TextWithIcon(icon: "apps.ipad", text: "Chủ đề", foreground: 0x009dff)
                
                TextWithIcon(icon: "textformat", text: "Ngôn ngữ", foreground: 0x26ad1a)
                
                NavigationLink(destination: PersonalizeView(onboard: false)) {
                    TextWithIcon(icon: "lock.fill", text: "Mật khẩu", foreground: 0xc90c61)
                }
            }
            
            Section {
                Button(action: {
                    self.showAlertLogout.toggle()
                }, label: {
                    TextWithIcon(icon: "arrowshape.turn.up.backward.fill", text: "Đăng xuất", foreground: 0xc90c61)
                })
            }
        }
        .resignKeyboardOnDragGesture()
        .background(Color(.secondarySystemBackground))
        .navigationTitle(Text("Cài đặt"))
        .navigationBarBackButtonHidden(true)
        .navigationBarTitle("Cài đặt")
        .navigationBarHidden(false)
        .navigationBarItems(leading: backButton)
        .alert(isPresented: $showAlertLogout, content: alert)
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
            message: Text(" Bạn sẽ tiếp tục đăng xuất?"),
            primaryButton: .default(Text("Tiếp tục")) {
                dismiss()
                viewModel.logout()
            },
            secondaryButton: .cancel(Text("Huỷ bỏ"))
        )
    }
    
    private func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}

struct TextWithIcon: View {
    
    var icon: String
    
    var text: String
    
    var foreground: Int
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .frame(width: 28, height: 28)
                .foregroundColor(.init(hex: foreground))
            Text(text)
        }
        .padding(5)
    }
}
