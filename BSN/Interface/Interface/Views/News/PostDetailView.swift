//
//  PostDetailView.swift
//  Interface
//
//  Created by Phucnh on 9/30/20.
//

import SwiftUI

struct PostDetailView: View {
    
    @StateObject private var viewModel: PostDetailViewModel = PostDetailViewModel()
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var postID: String = ""
    
    @State private var post: NewsFeed = NewsFeed()
    
    var didReact: ((NewsFeed) -> Void)?
    
    init(post: NewsFeed, didReact: ((NewsFeed) -> Void)? = nil) {
        self.post.clone(from: post)
        self.didReact = didReact
    }
    
    init(postID: String) {
        self._postID = State(initialValue: postID)
    }
    
    var body: some View {
        VStack {
            if viewModel.post != nil {
                postContent
            } else {
                ExceptionView(sign: "exclamationmark.circle", message: "Bài viết đã bị gỡ bỏ!")
            }
        }
        .embededLoadingFull(isLoading: $viewModel.isLoading)
        .navigationBarTitle("Bình luận", displayMode: .inline)
        .navigationBarHidden(false)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
        .onAppear(perform: viewAppeared)
    }
    
    var backButton: some View {
        Button {
            if let p = viewModel.post {
                didReact?(p)
            }            
            presentationMode.wrappedValue.dismiss()
        } label: {
            BackWardButton()
        }
    }
    
    var title: Text {
        Text("Bình luận").robotoBold(size: 13)
    }
    
    var postContent: some View {
        ZStack(alignment: .bottom) {
            ScrollView(.vertical) {
                // Main post
                NewsFeedCard(model: viewModel.post!, isDetail: true)
                
                Separator()
                
                HStack {
                    if viewModel.isLoadingComment {
                        CircleLoading(frame: CGSize(width: 15, height: 15))
                    } else {
                        if viewModel.canLoadMore {
                            Button {
                                viewModel.loadMore()
                            } label: {
                                Text("Tải thêm bình luận")
                                    .font(.system(size: 13))
                                    .foregroundColor(.black)
                                    .bold()
                            }
                        }
                    }
                    Spacer()
                }
                .padding(.leading, 25)
                
                // List comments
                //if viewModel.comments != nil {
                    ForEach(viewModel.comments) { comment in
                        CommentCard(model: comment) { (comment, name) in
                            viewModel.replingComment = comment
                            viewModel.replingName = name
                            viewModel.objectWillChange.send()
                        }
                    }
                    .environmentObject(viewModel)
               // }
                
                Spacer()
            }
            .padding(.bottom, 45)
            
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
                        .background(Color(.secondarySystemBackground))
                    
                    Button(action: {
                        // force to replace and emit signal to know we clear reply cmt
                        viewModel.replingComment = Comment(dummy: true)
                        viewModel.objectWillChange.send()
                    }, label: {
                        Image(systemName: "xmark")
                    })
                    .padding(2)
                    .background(Color(.secondarySystemBackground))
                    
                    Spacer()
                }
            }
            
            CoreMessageEditor(placeHolder: "Nhập bình luận") { (message) in
                viewModel.didComment(message: message)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
    
    func viewAppeared() {
        viewModel.prepareData(postID: postID, post: post)
    }
}

struct PostDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PostDetailView(post: NewsFeed())
    }
}
