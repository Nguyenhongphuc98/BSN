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
    
    @Published var comments: [Comment]
    
    // The comment will hold new subcomment
    @Published var replingComment: Comment = Comment(dummy: true)
    
    // the name of user be commented
    @Published var replingName: String
    
    var numCmtFetched: Int
    
    var currentPage: Int
    
    private var commentManager: CommentManager
    
    private var postManager: PostManager
    
    var canLoadMore: Bool {
        post?.numComment != numCmtFetched
    }
    
    override init() {
        self.isLoadingComment = false
        self.postID = ""
        self.replingName = ""
        commentManager = CommentManager()
        postManager = PostManager()
        comments = []
        numCmtFetched = 0
        currentPage = 0
        print("Did init post detail viewModel")
        
        super.init()

        observerSaveComment()
        observerFetchComments()
        observerFetchPost()
    }
    
    // Fetching post data and first comment page
    func prepareData(postID: String?, post: NewsFeed) {
        
        if post.id == kUndefine {
            self.postID = postID!
            isLoading = true
            // start loading post data
            postManager.getPost(pid: self.postID)
            
        } else {
            self.post = post
            self.postID = post.id
            self.objectWillChange.send()
            self.isLoading = false
        }
        
        if comments.isEmpty {
            // fetching comment - page 0
            isLoadingComment = true
            commentManager.getNewestComments(pid: self.postID, page: 0)
        }
    }
    
    func didComment(message: String) {
        
        let newLevel = replingComment.isDummy() ? 0 : 1
        let parent = replingComment.isDummy() ? postID : replingComment.id
        let finalMessage = newLevel == 0 ? message : "(\(replingName)) - " + message
        
        let eComment = EComment(
            userID: AppManager.shared.currenUID,
            postID: postID,
            parentID: parent,
            content: finalMessage
        )
        
        isLoadingComment = true
        commentManager.saveComment(comment: eComment)
    }
    
    func didDeleteComment(comment: Comment, complete: @escaping (Bool) -> Void) {
        // first level
        let id = comment.level == 0 ? comment.id : comment.parent
        let foundCommentIndex = comments.firstIndex(where: { $0.id == id })
        if comment.level == 0 {
            comments.remove(at: foundCommentIndex!)
        } else {
            let foundSubIndex = comments[foundCommentIndex!].subcomments.firstIndex(where: { $0.id == comment.id })
            comments[foundCommentIndex!].subcomments.remove(at: foundSubIndex!)
        }
        
        // To- Do
        // Call business to update data
        
        complete(true)
    }
    
    // Add comment on UI
    // Comments fetching from server
    // Or comment just save success by current user
    private func addComment(ec: EComment, ownerSave: Bool = false) {
        numCmtFetched += 1
        let cmt = Comment(
            id: ec.id!,
            parent: ec.parentID,
            owner: User(id: ec.userID, photo: ec.userPhoto == nil ? AppManager.shared.currentUser.avatar : ec.userPhoto, name: ec.userName ?? AppManager.shared.currentUser.displayname), // nil mean curent just comment
            content: ec.content,
            level: ec.parentID == ec.postID ? 0 : 1
        )
        
        if cmt.level == 0 {
            if ownerSave {
                self.comments.appendUnique(item: cmt)
            } else {
                self.comments.insertUnique(item: cmt)
            }
            
            // try to load subcomments
            self.commentManager.getSubComments(parentId: cmt.id)
        } else {
            let parentIndex = self.comments.firstIndex { $0.id == cmt.parent }!
            
            if ownerSave {
                self.comments[parentIndex].subcomments.appendUnique(item: cmt)
            } else {
                self.comments[parentIndex].subcomments.insertUnique(item: cmt)
            }
        }
    }
    
    func loadMore() {
        isLoadingComment = true
        currentPage += 1
        commentManager.getNewestComments(pid: self.postID, page: currentPage)
    }
}

// MARK: - Observer
extension PostDetailViewModel {
    private func observerSaveComment() {
        commentManager
            .commentPublisher
            .sink {[weak self] (ec) in
                
                guard let self = self else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.isLoadingComment = false
                    if ec.id == kUndefine {
                        self.resourceInfo =  .savefailure
                        self.showAlert = true
                    } else {
                        
                        self.addComment(ec: ec, ownerSave: true)
                        self.post?.numComment += 1
                        self.objectWillChange.send()
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    private func observerFetchComments() {
        commentManager
            .commentsPublisher
            .sink {[weak self] (cmts) in
                
                guard let self = self else {
                    return
                }
                
                DispatchQueue.main.async {
                    cmts.forEach { self.addComment(ec: $0) }
                    self.isLoadingComment = false
                    self.objectWillChange.send()
                }
            }
            .store(in: &cancellables)
    }
    
    private func observerFetchPost() {
        postManager
            .postPublisher
            .sink {[weak self] (p) in
                
                guard let self = self else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.isLoading = false
                    if p.id != kUndefine {
                        self.post = NewsFeed(post: p)
                        self.objectWillChange.send()
                    }
                }
            }
            .store(in: &cancellables)
    }
}
