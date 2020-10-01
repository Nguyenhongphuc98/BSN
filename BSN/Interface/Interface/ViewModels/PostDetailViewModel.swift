//
//  PostDetailViewModel.swift
//  Interface
//
//  Created by Phucnh on 9/30/20.
//

import SwiftUI

class PostDetailViewModel: ObservableObject {
    
    var postID: String
    
    @Published var isLoading: Bool
    
    @Published var post: NewsFeed?
    
    init(post: NewsFeed) {
        self.isLoading = false
        self.post = post
        self.postID = post.id
    }
    
    init(postID: String) {
        self.isLoading = true
        self.postID = postID
    }
    
    func fetchPost(by id: String, complete: @escaping (Bool) -> Void) {
        self.isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            if Int.random(in: 0..<2) == 1 {
                self.post = NewsFeed()
            }
            complete(false)
            withAnimation {
                self.isLoading = false
            }
        })
    }
}
