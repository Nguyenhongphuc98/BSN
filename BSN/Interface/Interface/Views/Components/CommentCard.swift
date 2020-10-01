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
    
    // 0 - cmt, 1- subcmt
    var level: Int = 0
    
    var body: some View {
        VStack {
            // Header
            HStack {
                CircleImage(image: model.owner.avatar, diameter: 30)
                
                VStack(alignment: .leading) {
                    Text(model.owner.displayname)
                        .font(.custom("Roboto-Bold", size: 13))
                    
                    CountTimeText(date: model.commentDate)
                }
                
                Spacer()
            }
            
            // Content
            VStack {
                if level == 0 {
                    Text(model.content)
                        +
                        Text(showSubcomments ? "  Ẩn trả lời" : "  Xem trả lời").foregroundColor(._primary).bold()
                } else {
                    Text(model.content)
                }
                
                if showSubcomments {
                    if model.subcomments != nil {
                        VStack {
                            ForEach(model.subcomments!) { subc in
                                CommentCard(model: subc, level: 1)
                            }
                        }
                    } else {
                        Text("Chưa có câu trả lời nào, hãy là người đầu tiên để lại bình luận")
                            .robotoLight(size: 13)
                    }
                    
                }
            }
            .font(.custom("Roboto-Light", size: 13))
            .fixedSize(horizontal: false, vertical: false)
            .onTapGesture {
                print("did tap")
                withAnimation {
                    self.showSubcomments.toggle()
                }
            }
            
            if level == 0 {
                Separator(color: .init(hex: 0xECE7E7), height: 2)
                    .padding(.leading, 5)
            }
        }
        .padding(.leading, 30).padding(.top, 20)
        .background(Color.white)
    }
}

struct CommentCard_Previews: PreviewProvider {
    static var previews: some View {
        CommentCard(model: Comment())
    }
}
