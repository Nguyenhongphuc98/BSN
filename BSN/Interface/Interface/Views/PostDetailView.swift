//
//  PostDetailView.swift
//  Interface
//
//  Created by Phucnh on 9/30/20.
//

import SwiftUI

struct PostDetailView: View {
    
    @ObservedObject private var viewModel: PostDetailViewModel
    
    @State private var presentPhoto: Bool = false
    
    @Environment(\.presentationMode) var presentationMode
    
    init(post: NewsFeed) {
        viewModel = PostDetailViewModel(post: post)
    }
    
    init(postID: String) {
        viewModel = PostDetailViewModel(postID: postID)
        viewModel.fetchPost(by: postID) { (result) in
            print("did fetch post")
        }
    }
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                Loading()
            } else {
                if viewModel.post != nil {
                    ScrollView(.vertical) {
                        // Main post
                        NewsFeedCard(model: viewModel.post!, isDetail: true, didTapPhoto: {
                            presentPhoto.toggle()
                        })
                        
                        Separator()
                        
                        // List comments
                        ForEach(1..<3) { _ in
                            CommentCard(model: Comment())
                        }
                        
                        Spacer()
                    }
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
}

struct PostDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PostDetailView(post: NewsFeed())
    }
}
