//
//  InChatView.swift
//  Interface
//
//  Created by Phucnh on 10/2/20.
//

import SwiftUI

struct InChatView: View {
    
    @StateObject var viewModel: InChatViewModel = InChatViewModel()
    
    @EnvironmentObject var root: RootViewModel
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var goProfile: Int? = 0
    
    var body: some View {
        ZStack(alignment: .bottom) {
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
                                MessageItem(message: message)
                                    .id(message.id)
                            }
                        }
                        .onAppear {
                            
                            value.scrollTo(viewModel.messages.last!.id)
                            viewModel.didSend = {
                                withAnimation {
                                    value.scrollTo(viewModel.messages.last!.id)
                                }
                            }
                        }
                    }
                }
                .resignKeyboardOnDragGesture()
                
                Spacer()
            }
            .padding(.bottom, 60)
            
            editorBox
        }
        .navigationBarTitle(viewModel.partner.displayname, displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton, trailing: profileButton)
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
            CircleImage(image: viewModel.partner.avatar, diameter: 20)
        }
    }
    
    var editorBox: some View {
        HStack {
            Button(action: {
                
            }, label: {
                Image(systemName: "photo.fill")
                    .resizable()
                    .frame(width: 25, height: 25)
                    .padding(5)
                    .foregroundColor(.gray)
            })
            
            Button(action: {
                
            }, label: {
                Image(systemName: "face.dashed.fill")
                    .resizable()
                    .frame(width: 25, height: 25)
                    .padding(.vertical, 5)
                    .foregroundColor(.gray)
            })
            
            CoreMessageEditor(placeHolder: "Nhập tin nhắn") { (message) in
                viewModel.didChat(message: message) { (success) in
                    print("did send: \(message)")
                }
            }
        }
        .background(Color._receiveMessage)
    }
}

struct InChatView_Previews: PreviewProvider {
    static var previews: some View {
        InChatView()
    }
}
