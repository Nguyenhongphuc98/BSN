//
//  CommentCard.swift
//  Interface
//
//  Created by Phucnh on 9/30/20.
//

import SwiftUI

struct CommentCard: View {
    
    @StateObject var model: Comment
    
    @State private var showSubcomments: Bool = false
    
    @State private var isShowProfile: Bool = false
    
    @State private var showingViewFull: Bool = false
    
    @EnvironmentObject var pdViewModel: PostDetailViewModel
    
    // Reply in subcomment of 'Comment' and who be reppled is 'String'
    var didRequestReply: ((Comment, String) -> Void)?
    
    var body: some View {
        VStack {
            header
            
            // Content
            VStack(alignment: .leading) {
                // Expand box to fit width screen
                expanseW
                
                VStack {
                    // Allow expan comment if first level
                    // If it have subcomments
                    if model.level == 0 && !model.subcomments.isEmpty {
                        Text(model.content)
                            +
                            Text(showSubcomments ? "  Ẩn trả lời" : "  Xem trả lời").foregroundColor(.black).bold()
                    } else {
                        Text(model.content)
                            //.fixedSize(horizontal: true, vertical: false)
                    }
                }
                .onTapGesture {
                    // Just first level can expanse
                    print("did tap")
                    if model.level == 0 {
                        withAnimation {
                            self.showSubcomments.toggle()
                        }
                    }
                }
                
                image
                
                replyButton
                
                if showSubcomments {
                    subcomments
                }
            }
            .padding(.trailing, 10)
            .padding(.leading, 20)
            .font(.custom("Roboto-Light", size: 13))
            .fixedSize(horizontal: false, vertical: true)
            
            
            // Just seperator between first level
            if model.level == 0 {
                seperator
            }
        }
        .padding(.leading, 20)
        .background(Color.white)
    }
    
    var header: some View {
        // Header
        HStack {
            avatar
            
            VStack(alignment: .leading) {
                Text(model.owner.displayname)
                    .font(.custom("Roboto-Bold", size: 13))
                
                CountTimeText(date: model.commentDate)
            }
            
            Spacer()
            
            if model.owner.isCurrentUser() {
                Menu {
                    Button {
                        pdViewModel.didDeleteComment(comment: model)
                    } label: {
                        Text("Xoá bình luận")
                    }
                }
                label: {
                    // More button
                    Image(systemName: "ellipsis")
                    .padding(.bottom)
                    .padding(.trailing)
                }
            }
        }
        .frame(height: 40)
    }
    
    private var avatar: some View {
        Group {
            NavigationLink(
                destination: ProfileView(uid: model.owner.id, vm: ProfileViewModel())
                    .environmentObject(NavigationState()),
                isActive: $isShowProfile
            ) {
                EmptyView()
            }
            .frame(width: 0, height: 0)
            .opacity(0)
            
            Button {
                isShowProfile = true
            } label: {
                CircleImage(image: model.owner.avatar, diameter: 30)
            }
            .buttonStyle(BorderlessButtonStyle())
        }
    }
    
    private var image: some View {
        Group {
            if model.sticker != nil {
                Image(model.sticker!, bundle: interfaceBundle)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 90)
            }
            
            if model.photo != nil {
                Button(action: {
                    showingViewFull.toggle()
                }, label: {
                    BSNImage(urlString: model.photo, tempImage: "unavailable")
                        .frame(height: 150)
                })
                .buttonStyle(PlainButtonStyle())
                .fullScreenCover(isPresented: $showingViewFull) {
                    ZoomableScrollImage(url: model.photo!) {
                        self.showingViewFull.toggle()
                    }
                }
            }
        }
        .clipped()
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }
    
    var expanseW: some View {
        HStack {
            Spacer()
        }
    }
    
    var subcomments: some View {
        VStack {
            ForEach(model.subcomments) { subc in
                CommentCard(model: subc) { _, n in
                    didRequestReply?(model, n)
                }.id(UUID())
            }
        }
    }
    
    var replyButton: some View {
        HStack {
            Button(action: {
                didRequestReply?(model, model.owner.displayname)
            }, label: {
                Text("Trả lời")
                    .robotoBold(size: 13)
                    .foregroundColor(._secondary)
            })
            .padding(0)
            
            Spacer()
        }
    }
    
    var seperator: some View {
        Separator(color: .init(hex: 0xECE7E7), height: 2)
            .padding(.leading, 5)
    }
}

struct CommentCard_Previews: PreviewProvider {
    static var previews: some View {
        CommentCard(model: Comment())
    }
}
