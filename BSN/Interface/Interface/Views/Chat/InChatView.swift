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
            navProfile
            
            // Messages
            VStack {
                           
                ScrollView {
                    ScrollViewReader { value in
                
                        VStack {
                            loadMore
                            
                            ForEach(viewModel.messages) { message in
                                MessageCel(message: message)
                                    .id(message.id)
                                    .environmentObject(viewModel.chat)
                            }
                        }
                        .onAppear {
                            viewModel.updateUIIfNeedes = {

                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                    withAnimation {
                                        value.scrollTo(viewModel.messages.last?.id ?? "", anchor: .bottom)
                                        print("*** scroll to-")
                                    }
                                }
                            }
                        }
                    }
                }
                .resignKeyboardOnDragGesture()
                
                Spacer()
            }
            .padding(.bottom, chatBottom)            
            .embededLoadingFull(isLoading: $viewModel.isLoading)
            
            editor
            
            // Progess bar (uploading)
            if viewModel.isUploading {
                ProgressView("Đang xử lý ảnh", value: viewModel.uploadProgess, total: 1)
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding(.bottom, 300)
            }
        }
        .alert(isPresented: $viewModel.showAlert, content: alert)
        .navigationBarTitle(viewModel.chat.partnerName, displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton, trailing: profileButton)
        .onAppear(perform: viewAppeard)
    }
    
    private var navProfile: some View {
        NavigationLink(
            destination: ProfileView(uid: chat.partnerID)
                .environmentObject(NavigationState()),
            tag: 1,
            selection: $goProfile
        ) {
            EmptyView()
        }
        .frame(width: 0, height: 0)
        .opacity(0)
    }
    
    private var loadMore: some View {
        Group {
            if viewModel.isLoadmore {
                CircleLoading(frame: CGSize(width: 20, height: 20))
            }
            
            if !viewModel.allMessageFetched && !viewModel.isLoadmore {
                Button {
                    viewModel.loadMoreMessages()
                } label: {
                    Text("Tải thêm")
                        .frame(maxWidth: .infinity)
                        .background(Color(.secondarySystemBackground))
                        .foregroundColor(.black)
                }
            }
        }
    }
    
    private var editor: some View {
        VStack(spacing: 0) {
            Spacer()

            //editorBox
            RichMessageEditor(didChat: { (type, message) in
                viewModel.didChat(type: type, content: message)
            }, didPickPhoto: { (img) in
                viewModel.upload(image: img)
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
    
    var backButton: some View {
        Button {
            // When receive new message, it update to not seen
            // But actualy we just leave in this chat
            // So, it should be mark seen
            viewModel.markSeen()
            presentationMode.wrappedValue.dismiss()
        } label: {
            BackWardButton()
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
