//
//  PostDetailView.swift
//  Interface
//
//  Created by Phucnh on 9/30/20.
//

import SwiftUI

struct PostDetailView: View {
    
    @StateObject private var viewModel: PostDetailViewModel = PostDetailViewModel()
    
    @State private var presentPhoto: Bool = false
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var postID: String = ""
    
    init(post: NewsFeed) {
        //print("Post detail apeared")
        //viewModel = PostDetailViewModel(post: post)
    }
    
    init(postID: String) {
        //print("Post detail apeared")
        //viewModel = PostDetailViewModel(postID: postID)
        
//        viewModel.fetchPost(by: postID) { (result) in
//            print("did fetch post")
//        }
        self.postID = postID
    }
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                Loading()
            } else {
                if viewModel.post != nil {
                    postContent
                } else {
                    ExceptionView(sign: "exclamationmark.circle", message: "Bài viết đã bị gỡ bỏ!")
                }
            }
        }
        .navigationBarTitle("Bình luận", displayMode: .inline)
        .navigationBarHidden(false)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
        .fullScreenCover(isPresented: $presentPhoto) {
            ViewFullPhoto(newFeed: viewModel.post!)
        }
        .onAppear {
            print("Post detail apeared")
            viewModel.fetchPost(by: postID) { (result) in
                print("did fetch post")
            }
        }
    }
    
    var backButton: some View {
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            Image(systemName: "chevron.backward")
                .foregroundColor(.gray)
        }
        
    }
    
    var title: Text {
        Text("Bình luận").robotoBold(size: 13)
    }
    
    var postContent: some View {
        ZStack(alignment: .bottom) {
            ScrollView(.vertical) {
                // Main post
                NewsFeedCard(model: viewModel.post!, isDetail: true, didTapPhoto: {
                    presentPhoto.toggle()
                })
                
                Separator()
                
                // List comments
                if viewModel.comments != nil {
                    ForEach(viewModel.comments!) { comment in
                        CommentCard(model: comment) { (comment, name) in
                            viewModel.replingComment = comment
                            viewModel.replingName = name
                        }
                    }
                    .environmentObject(viewModel)
                }
                
                Spacer()
            }
            .padding(.bottom, 60)
            
            commentBox
        }
    }
    
    var commentBox: some View {
        VStack(spacing: 1) {
            if !viewModel.replingComment.isDummy() {
            HStack(spacing: 0) {
                Text("Bạn đang trả lời \(viewModel.replingName)...")
                    .foregroundColor(._primary)
                    .robotoLightItalic(size: 15)
                    .background(Color.init(hex: 0xDCDCDC))
                    
                Button(action: {
                    // force to replace and emit signal to know we clear reply cmt
                    viewModel.replingComment = Comment(dummy: true)
                }, label: {
                    Image(systemName: "xmark")
                })
                .padding(2)
                .background(Color.init(hex: 0xDCDCDC))
                
                Spacer()
            }
            }
            
            CoreMessageEditor(placeHolder: "Nhập bình luận") { (message) in
                viewModel.didComment(message: message) { (success) in
                    print("Did comment: \(message) - \(success)")
                }
            }
        }
    }
}

struct PostDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PostDetailView(post: NewsFeed())
    }
}
