//
//  ProfileViewModel.swift
//  BSN
//
//  Created by Phucnh on 9/23/20.
//

import Foundation
import Combine
import UIKit
import Business
import SwiftUI

public class ProfileViewModel: NetworkViewModel {
    
    public static let shared: ProfileViewModel = .init()
    
    @Published var posts: [NewsFeed]
    @Published var books: [BUserBook]
    @Published var displayBooks: [BUserBook]
    @Published public var user: User
    @Published public var userFollow: EUserfollow
    
    private var userBookManager: UserBookManager
    private var userManager: UserManager
    private var followManager: UserFollowManager
    private var postManager: PostManager
    
    private var isfetched: Bool // all data fetched before
    
    // Search internal books
    @Published var isFocus: Bool
    @Published var searchText: String
    
    // Upload image to S3
    @Published var uploadProgess: Float
    @Published var isUploading: Bool
    
    public override init() {
        user = User()
        posts = []
        books = []
        displayBooks = []
        userFollow = EUserfollow()
        isfetched = false       
        userBookManager = .init()
        userManager = UserManager()
        followManager = UserFollowManager()
        postManager = PostManager()
        
        isFocus = false
        searchText = ""
        
        uploadProgess = 0
        isUploading = false
        
        super.init()
        observerUserBookInfo()
        observerUserInfo()
        observerUserFollow()
        observerNewestPosts()
        setupSearchInternal()
    }
    
    func setupSearchInternal() {
        self.$isFocus.sink { (isFocus) in
            if !isFocus {
                self.displayBooks = self.books
            }
        }
        .store(in: &cancellables)
        
        self.$searchText.sink { (text) in
            if text.isEmpty {
                self.displayBooks = self.books
            } else {
                self.displayBooks = self.books.filter({ $0.title.lowercased().contains(text.lowercased()) })
            }
        }
        .store(in: &cancellables)
    }
    
    public func forceRefeshData() {
        // Just current user can force refesh
        self.user = AppManager.shared.currentUser
        reloadPostNUserbook()
    }
    
    public func forceRefeshUB() {
        self.books = []
        userBookManager.getUserBooks(uid: self.user.id)
    }
    
    /// Fetching data from Server to fill page if it passed bookID from preView
    // This func should be call one time
    public func prepareData(uid: String?) {
        guard isLoading == false, !isfetched else {
            return
        }
        isLoading = true
        
        if uid == nil || uid == AppManager.shared.currentUser.id {
            // Show info of current user
            self.user = AppManager.shared.currentUser
        } else {
            print("did load guest profile ...")
            // fetch info of other user
            userManager.getUser(uid: uid!)
            // Check followed?
            followManager.getUserFollow(followerId: AppManager.shared.currentUser.id, userID: uid!)
        }
        
        reloadPostNUserbook(uid: uid)
    }
    
    func reloadPostNUserbook(uid: String? = nil) {
        self.books = []
        self.posts = []
        self.displayBooks = []
        userBookManager.getUserBooks(uid: uid ?? self.user.id)
        postManager.getPersonalNewestPosts(page: 0, uid: uid ?? self.user.id)
    }
    
    func processFollow() {
        // 1. follow
        // 2. cancel follow req
        // 3. unfollow
        
        if userFollow.id == nil || userFollow.id == kUndefine {
            // not follow before
            // make follow request
            let follow = EUserfollow(uid: user.id, followerId: AppManager.shared.currenUID)
            followManager.makeFollow(follow: follow)
        } else {
            // accepted or not
            // we don't care. this action will remove record
            // so will no longer waiting or follow
            // make unfollow request
            followManager.unfollow(followerId: AppManager.shared.currenUID, targetId: user.id)
        }
        
//        if followed.ac {
//            // make unfollow request
//            followManager.unfollow(followerId: AppManager.shared.currenUID, targetId: user.id)
//        } else {
//            // make follow
//            let follow = EUserfollow(uid: user.id, followerId: AppManager.shared.currenUID)
//            followManager.makeFollow(follow: follow)
//        }
        
//        followed = !followed
    }
    
    func addNewPostToTop(news: NewsFeed) {
        DispatchQueue.main.async {
            self.posts.insertUnique(item: news)
            self.objectWillChange.send()
        }
    }
    
    func deletePost(pid: String) {
        willDeletePost(pid: pid)
        NewsFeedViewModel.shared.willDeletePost(pid: pid)
        postManager.deletePost(postID: pid)
    }
    
    func willDeletePost(pid: String) {
        guard let index = posts.firstIndex(where: { $0.id == pid }) else {
            return
        }
        
        withAnimation {
            _ = posts.remove(at: index)
            objectWillChange.send()
        }
    }
}

// MARK: - Observer data
extension ProfileViewModel {
    /// UserBook get from server  will received at this block
    private func observerUserBookInfo() {
        /// Get user-book by uid to load on UI
        userBookManager
            .getUserBooksPublisher
            .sink {[weak self] (ubs) in
                
                guard let self = self else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.isfetched = true
                    
                    if !ubs.isEmpty {
                        
                        ubs.forEach { (ub) in
                            
                            let userBook = BUserBook(
                                ubid: ub.id!,
                                bookID: ub.bookID!,
                                uid: ub.userID!,
                                status: ub.status,
                                title: ub.title!,
                                author: ub.author!,
                                state: ub.state,
                                cover: ub.cover
                            )
                            self.books.appendUnique(item: userBook)
                        }
                        //if self.displayBooks.isEmpty {
                            self.displayBooks = self.books
                        //}
                        self.objectWillChange.send()
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    private func observerUserInfo() {
        userManager
            .getUserPublisher
            .sink {[weak self] (u) in
                
                guard let self = self else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.isfetched = true
                    
                    if u.id == "undefine" {
                        self.resourceInfo = .notfound
                        self.showAlert.toggle()
                    } else {
                        self.user = User(
                            id: u.id!,
                            username: "unknow",
                            displayname: u.displayname!,
                            avatar: u.avatar,
                            cover: u.cover,
                            location: u.location,
                            about: u.about
                        )
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    private func observerUserFollow() {
        followManager
            .getFollowingPublisher
            .sink {[weak self] (uf) in
                
                guard let self = self else {
                    return
                }
                
                DispatchQueue.main.async {

//                    if uf.id == "undefine" || uf.id == nil {
//                        self.followed = false
//                    } else {
//                        self.followed = true
//                    }
                    
                    if !(uf.id == "undefine" || uf.id == nil) {
                        self.userFollow = uf
                        self.objectWillChange.send()
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    private func observerNewestPosts() {
        postManager
            .postsPublisher
            .sink {[weak self] (posts) in
                
                guard let self = self else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.isLoading = false
                    
                    posts.forEach { p in
                        let newfeed = NewsFeed(post: p)
                        self.posts.appendUnique(item: newfeed)
                    }
                    self.objectWillChange.send()
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - AWS Utils
extension ProfileViewModel {
    func upload(image: UIImage, for type: ActionSheetType) {
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
                 
                // Update current display data
                // Send to update server side
                if type == .Avatar {
                    AppManager.shared.currentUser.avatar = finalPath
                    strongSelf.userManager.updateUser(user: EUser(
                        id: AppManager.shared.currenUID,
                        avatar: finalPath
                    ))
                } else {
                    AppManager.shared.currentUser.cover = finalPath
                    strongSelf.userManager.updateUser(user: EUser(
                        id: AppManager.shared.currenUID,
                        cover: finalPath
                    ))
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
