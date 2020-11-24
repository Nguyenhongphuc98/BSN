//
//  PostDetailViewModel.swift
//  Interface
//
//  Created by Phucnh on 9/30/20.
//

import SwiftUI
import Business

class PostDetailViewModel: NetworkViewModel {
    
    var postID: String
    
    @Published var isLoadingComment: Bool
    
    @Published var post: NewsFeed?
    
    @Published var comments: [Comment]?
    
    // The comment will hold new subcomment
    @Published var replingComment: Comment = Comment(dummy: true)
    
    // the name of user be commented
    @Published var replingName: String
    
    private var commentManager: CommentManager
    
    override init() {
        self.isLoadingComment = false
        self.postID = ""
        self.replingName = ""
        commentManager = CommentManager()
        print("Did init post detail viewModel")
        super.init()
        self.isLoading = true
        observerSaveComment()
    }
    
    // Fetching post data and first comment page
    func prepareData(postID: String?, post: NewsFeed) {
        
        if post.id == kUndefine {
            isLoading = true
            self.postID = postID!
            // start loading post data
        } else {
            self.post = post
            self.postID = post.id
            self.objectWillChange.send()
            self.isLoading = false
        }
        
        if comments == nil {
            // fetching comment - page 0
        }
    }
    
    func didComment(message: String) {
        
        let newLevel = replingComment.isDummy() ? 0 : 1
        let parent = replingComment.isDummy() ? postID : replingComment.id
        let finalMessage = newLevel == 0 ? message : "(\(replingName)) - " + message
        let newComment = Comment(
            parent: parent,
            owner: AppManager.shared.currentUser,
            content: finalMessage,
            level: newLevel
        )

        // Comment on post
        if newLevel == 0 {
            
            withAnimation {
                if comments == nil {
                    comments = [newComment]
                } else {
                    // Newest comment lv0 will be in top
                    self.comments?.insert(newComment, at: 0)
                }
            }
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
        }
        
        let eComment = EComment(
            userID: AppManager.shared.currenUID,
            postID: postID,
            parentID: parent,
            content: finalMessage
        )
        
        commentManager.saveComment(comment: eComment)
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

// MARK: - Observer
extension PostDetailViewModel {
    private func observerSaveComment() {
        commentManager
            .commentPublisher
            .sink {[weak self] (c) in
                
                guard let self = self else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.isLoading = false
                    if c.id == kUndefine {
                        self.resourceInfo =  .savefailure
                        self.showAlert = true
                    }
                    // Don't action when save success
                }
            }
            .store(in: &cancellables)
    }
}
