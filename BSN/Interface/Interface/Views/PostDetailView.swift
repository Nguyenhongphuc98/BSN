//
//  PostDetailView.swift
//  Interface
//
//  Created by Phucnh on 9/30/20.
//

import SwiftUI

struct PostDetailView: View {
    
    @StateObject private var viewModel: PostDetailViewModel
    
    @State private var presentPhoto: Bool = false
    
    @Environment(\.presentationMode) var presentationMode
    
    init(post: NewsFeed) {
        self._viewModel = StateObject(wrappedValue: PostDetailViewModel(post: post))
    }
    
    var body: some View {
        VStack {
            ScrollView(.vertical) {
                // Main post
                NewsFeedCard(model: viewModel.post, isDetail: true, didTapPhoto: {
                    presentPhoto.toggle()
                })
                
                Separator()
                
                // List comments
                
                ForEach(1..<3) { _ in
                    CommentCard(comment: Comment())
                }
                
                Spacer()
            }
        }
        .navigationBarTitle("Bình luận", displayMode: .inline)
        .navigationBarHidden(false)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
        .fullScreenCover(isPresented: $presentPhoto) {
            ViewFullPhoto(newFeed: viewModel.post)
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
