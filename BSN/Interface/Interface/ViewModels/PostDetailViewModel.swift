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
    
    @Published var comments: [Comment]?
    
    // The comment will hold new subcomment
    @Published var replingComment: Comment = Comment(dummy: true)
    
    // the name of user be commented
    @Published var replingName: String
    
    private var neededFetchPost: Bool
    
    init(post: NewsFeed) {
        self.isLoading = false
        self.post = post
        self.postID = post.id
        self.replingName = ""
        self.neededFetchPost = true
    }
    
    init(postID: String) {
        self.isLoading = true
        self.postID = postID
        self.replingName = ""
        self.neededFetchPost = true
    }
    
    init() {
        self.isLoading = true
        self.postID = ""
        self.replingName = ""
        self.neededFetchPost = true
        print("Did iit post detail viewModel")
    }
    
    func fetchPost(by id: String, complete: @escaping (Bool) -> Void) {
        if neededFetchPost {
            self.neededFetchPost = false
            self.isLoading = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                if Int.random(in: 0..<4) != 1 {
                    self.post = NewsFeed()
                    self.comments = [Comment(), Comment()]
                }
                complete(false)
                withAnimation {
                    self.isLoading = false
                }
            })
        }
    }
    
    func didComment(message: String, complete: @escaping (Bool) -> Void) {
        
        let newLevel = replingComment.isDummy() ? 0 : 1
        let parent = replingComment.isDummy() ? postID : replingComment.id
        let finalMessage = newLevel == 0 ? message : "(\(replingName)) - " + message
        let newComment = Comment(
            parent: parent,
            owner: RootViewModel.shared.currentUser,
            content: finalMessage,
            level: newLevel
        )
        
        // Comment on post
        if  newLevel == 0 {
            
            withAnimation {
                if comments == nil {
                    comments = [newComment]
                } else {
                    // Newest comment lv0 will be in top
                    self.comments?.insert(newComment, at: 0)
                }
            }
            
            // To-Do
            // Call Busseness push cmt to server
        } else {
            
            // On comment
            withAnimation {
                if replingComment.subcomments == nil {
                    replingComment.subcomments = [newComment]
                } else {
                    // Newest comment lv1 will be in bottom
                    replingComment.subcomments?.append(newComment)
                }
            }
            
            // To-Do
            // Call Busseness push cmt to server
        }
        
        complete(true)
        
//        for cmt in comments! {
//            print("item: - \(cmt.owner.displayname) - \(cmt.content)")
//        }
    }
    
    func didDeleteComment(comment: Comment, complete: @escaping (Bool) -> Void) {
        // first level
        let id = comment.level == 0 ? comment.id : comment.parent
        let foundCommentIndex = comments?.firstIndex(where: { $0.id == id })
        if comment.level == 0 {
            comments?.remove(at: foundCommentIndex!)
        } else {
            let foundSubIndex = comments?[foundCommentIndex!].subcomments?.firstIndex(where: { $0.id == comment.id })
            comments?[foundCommentIndex!].subcomments?.remove(at: foundSubIndex!)
        }
        
        // To- Do
        // Call business to update data
        
        complete(true)
    }
}
