//
//  PostDetailViewModel.swift
//  Interface
//
//  Created by Phucnh on 9/30/20.
//

import SwiftUI

class PostDetailViewModel: ObservableObject {
    
    @Published var post: NewsFeed
    
    init(post: NewsFeed) {
        self.post = post
    }
}
