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
    
    // Upload image to S3
    @Published var uploadProgess: Float
    @Published var isUploading: Bool
    @Published var uploadedPhoto: String
    
    @Published var uploadedSticker: String
    
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
        
        uploadProgess = 0
        isUploading = false
        uploadedPhoto = ""
        uploadedSticker = ""
        
        numCmtFetched = 0
        currentPage = 0
        print("Did init post detail viewModel")
        
        super.init()

        observerSaveComment()
        observerFetchComments()
        observerFetchPost()
        receiveNewComment()
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
            content: finalMessage,
            photo: self.uploadedPhoto.isEmpty ? nil : self.uploadedPhoto,
            sticker: self.uploadedSticker.isEmpty ? nil : self.uploadedSticker
        )
        
        isLoadingComment = true
        commentManager.saveComment(comment: eComment)
    }
    
    func didDeleteComment(comment: Comment) {
        // first level
        let id = comment.level == 0 ? comment.id : comment.parent
        let foundCommentIndex = comments.firstIndex(where: { $0.id == id })
        let totalCmtWillDelete = 1 + comment.subcomments.count
        
        if comment.level == 0 {
            comments.remove(at: foundCommentIndex!)
        } else {
            let foundSubIndex = comments[foundCommentIndex!].subcomments.firstIndex(where: { $0.id == comment.id })
            comments[foundCommentIndex!].subcomments.remove(at: foundSubIndex!)
        }
        
        // num comment and num fetch comment shoud update
        self.post?.numComment -= totalCmtWillDelete
        self.numCmtFetched -= totalCmtWillDelete
                
        self.objectWillChange.send()
        commentManager.deleteComment(commentID: comment.id)
    }
    
    // Add comment on UI
    // Comments fetching from server
    // Or comment just save success by current user
    // Newest comment will show at bottom, so when receive next page cmts, we add to top (first of array)
    private func addComment(ec: EComment, ownerSave: Bool = false, addToTop: Bool) {
        numCmtFetched += 1
        let cmt = Comment(
            id: ec.id!,
            parent: ec.parentID,
            owner: User(id: ec.userID, photo: ownerSave ? AppManager.shared.currentUser.avatar : ec.userPhoto, name: ownerSave ? AppManager.shared.currentUser.displayname : ec.userName!), // nil mean curent just comment
            content: ec.content,
            level: ec.parentID == ec.postID ? 0 : 1,
            cmtDate: ec.createdAt,
            photo: ec.photo,
            sticker: ec.sticker
        )
        
        if cmt.level == 0 {
            if addToTop {
                self.comments.insertUnique(item: cmt)
            } else {
                self.comments.appendUnique(item: cmt)
            }
            
            // try to load subcomments
            self.commentManager.getSubComments(parentId: cmt.id)
        } else {
            let parentIndex = self.comments.firstIndex { $0.id == cmt.parent }!
            
            // In subcomment level, because we get all subcmt, so just one case, insert on top
//            if addToTop {
                self.comments[parentIndex].subcomments.appendUnique(item: cmt)
//            } else {
                //self.comments[parentIndex].subcomments.insertUnique(item: cmt)
            //}
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
                        
                        // save comment will newest, and don't add to top
                        self.addComment(ec: ec, ownerSave: true, addToTop: false)
                        self.post?.numComment += 1
                        self.uploadedPhoto = ""
                        self.uploadedSticker = ""
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
                    // Fetch comments should add to top, older on top
                    cmts.forEach { self.addComment(ec: $0, addToTop: true) }
                    self.isLoadingComment = false
                    self.objectWillChange.send()
                }
            }
            .store(in: &cancellables)
    }
    
    // If nav from notify, we have to fetch post
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

    // MARK: - WebSocket
    // WebSocket send new comment to this post
    private func receiveNewComment() {
        commentManager
            .receiveCommentPublisher
            .sink {[weak self] (cmt) in
                
                guard let self = self else {
                    return
                }
                
                DispatchQueue.main.async {
                    // If this comment send by current user
                    // It should updated by receive save message
                    // So, just ignore
                    if cmt.userID == AppManager.shared.currenUID { return }
                    // New comment will add to bottom
                    self.addComment(ec: cmt, addToTop: false)
                    // num comment shoud update
                    self.post?.numComment += 1
                    self.objectWillChange.send()
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - AWS Utils
extension PostDetailViewModel {
    func upload(image: UIImage) {
        print("start uploading image ...")
        isUploading = true
        objectWillChange.send()
        AWSManager.shared.uploadImage(image: image, progress: {[weak self] ( uploadProgress) in
            
            guard let strongSelf = self else { return }
            strongSelf.uploadProgess = Float(uploadProgress)
            print("uploading: \(uploadProgress)")
            
        }) {[weak self] (uploadedFileUrl, error) in
            
            guard let strongSelf = self else { return }
            if let finalPath = uploadedFileUrl as? String {
                
                withAnimation {
                    strongSelf.uploadedPhoto = finalPath
                }
            } else {
                //strongSelf.photoUrl = ""
                strongSelf.resourceInfo = .image_upload_fail
                strongSelf.showAlert = true
                print("\(String(describing: error?.localizedDescription))")
            }
            strongSelf.isUploading = false
            strongSelf.objectWillChange.send()
        }
    }
}
