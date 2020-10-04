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
    
    @EnvironmentObject var partner: User
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var goProfile: Int? = 0
    
    @State var chatBottom: CGFloat = 45

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
                                    MessageItem(message: message)
                                        .id(message.id)
                                }
                            }
                            .onAppear {
                                
                                value.scrollTo(viewModel.messages.last!.id)
                                viewModel.updateUIIfNeedes = {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: {
                                        withAnimation {
                                            value.scrollTo(viewModel.messages.last!.id)
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
                    viewModel.didChat(type: type, content: message) { (success) in
                        print("did send: \(message) - \(success)")
                    }
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
        .navigationBarTitle(viewModel.partner.displayname, displayMode: .inline)
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
            CircleImage(image: viewModel.partner.avatar, diameter: 20)
        }
    }
    
    func viewAppeard() {
        viewModel.fetchData(partner: partner)
    }
}

struct InChatView_Previews: PreviewProvider {
    static var previews: some View {
        InChatView()
    }
}
