//
//  InChatView.swift
//  Interface
//
//  Created by Phucnh on 10/2/20.
//

import SwiftUI

struct InChatView: View {
    
    @EnvironmentObject var chat: Chat
    
    @StateObject var viewModel: InChatViewModel = InChatViewModel()
    
    @EnvironmentObject var root: AppManager
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var goProfile: Int? = 0
    
    @State private var chatBottom: CGFloat = 45

    var body: some View {
        ZStack(alignment: .bottom) {
            if !viewModel.isLoading {
                NavigationLink(destination: ProfileView(), tag: 1, selection: $goProfile) {
                    EmptyView()
                }
                .frame(width: 0, height: 0)
                .opacity(0)
                
                VStack {
                    Separator(color: .white, height: 2)
                    
                    ScrollView {
                        ScrollViewReader { value in
                            LazyVStack {
                                ForEach(viewModel.messages) { message in
                                    MessageCel(message: message)
                                        .id(message.id)
                                        .environmentObject(viewModel.chat)
                                }
                            }
                            .onAppear {
                                
                                value.scrollTo(viewModel.messages.last?.id ?? "")
                                viewModel.updateUIIfNeedes = {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15, execute: {
                                        withAnimation {
                                            value.scrollTo(viewModel.messages.last?.id ?? "")
                                            print("did force update UI")
                                        }
                                    })
                                }
                            }
                        }
                    }
                    .resignKeyboardOnDragGesture()
                    
                    Spacer()
                }
                .padding(.bottom, chatBottom)
            }
            
            VStack(spacing: 0) {
                Spacer()
                
                if viewModel.isLoading {
                    Loading()
                    Spacer()
                }

                //editorBox
                RichMessageEditor(didChat: { (type, message) in
                    viewModel.didChat(type: type, content: message)
                }, didPickPhoto: { (data) in
                    
                    viewModel.photo = data
                    viewModel.didChat(type: .photo)
                }, didExpand: { expand, type in
                    
                    // Keyboard height (253) +  editText height (45) = 298
                    // Just need adapt sticker showing
                    if type == .sticker {
                        chatBottom = expand ? 298 : 45
                    } else {
                        chatBottom = 45
                    }
                    
                    viewModel.updateUIIfNeedes?()
                })
            }
        }
        .alert(isPresented: $viewModel.showAlert, content: alert)
        .navigationBarTitle(viewModel.chat.partnerName, displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton, trailing: profileButton)
        .onAppear(perform: viewAppeard)
    }
    
    var backButton: some View {
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            Image(systemName: "chevron.backward")
                .foregroundColor(.gray)
        }
    }
    
    var profileButton: some View {
        Button {
            goProfile = 1
        } label: {
            CircleImage(image: viewModel.chat.partnerPhoto, diameter: 20)
        }
    }
    
    func alert() -> Alert {
        return Alert(
            title: Text("Kết quả"),
            message: Text(viewModel.resourceInfo.des()),
            dismissButton: .default(Text("OK")) {
                // Remove last message because save fail
                if viewModel.resourceInfo == .savefailure {
                    viewModel.messages.removeLast()
                }
            })
    }
    
    func viewAppeard() {
        viewModel.fetchData(chat: chat)
    }
}

struct InChatView_Previews: PreviewProvider {
    static var previews: some View {
        InChatView()
    }
}
