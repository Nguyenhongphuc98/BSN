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
                    if model.level == 0 && model.subcomments != nil {
                        Text(model.content)
                            +
                            Text(showSubcomments ? "  Ẩn trả lời" : "  Xem trả lời").foregroundColor(._primary).bold()
                    } else {
                        Text(model.content)
                            .fixedSize(horizontal: false, vertical: false)
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
                
                replyButton
                
                if showSubcomments && model.subcomments != nil {
                    subcomments
                }
            }
            .padding(.trailing, 10)
            .font(.custom("Roboto-Light", size: 13))
            .fixedSize(horizontal: false, vertical: false)
            
            
            // Just seperator between first level
            if model.level == 0 {
                seperator
            }
        }
        .padding(.leading, 30)
        .background(Color.white)
    }
    
    var header: some View {
        // Header
        HStack {
            CircleImage(image: model.owner.avatar, diameter: 30)
            
            VStack(alignment: .leading) {
                Text(model.owner.displayname)
                    .font(.custom("Roboto-Bold", size: 13))
                
                CountTimeText(date: model.commentDate)
            }
            
            Spacer()
            
            if model.owner.username == RootViewModel.shared.currentUser.username {
                Menu {
                    Button {
                        pdViewModel.didDeleteComment(comment: model) { (success) in
                            print("did delete cmt: \(success)")
                        }
                    } label: {
                        Text("Xoá bình luận")
                    }
                }
                label: {
                    // More button
                    Image(systemName: "ellipsis")
//                    StickyImageButton(normal: "ellipsis",
//                                      active: "ellipsis.rectangle.fill",
//                                      color: .black) { (isMore) in
//                        print("did request more: \(isMore)")
//                    }
                    .padding(.bottom)
                    .padding(.trailing)
                }
            }
        }
    }
    
    var expanseW: some View {
        HStack {
            Spacer()
        }
    }
    
    var subcomments: some View {
        VStack {
            ForEach(model.subcomments!) { subc in
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
