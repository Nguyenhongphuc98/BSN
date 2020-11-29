//
//  ProfileViewModel.swift
//  BSN
//
//  Created by Phucnh on 9/23/20.
//

import Foundation
import Business
import Combine

public class ProfileViewModel: NetworkViewModel {
    
    public static let shared: ProfileViewModel = ProfileViewModel()
    
    @Published var posts: [NewsFeed]
    
    @Published var books: [BUserBook]
    
    @Published public var user: User
    
    @Published public var followed: Bool
    
    private var userBookManager: UserBookManager
    
    private var userManager: UserManager
    
    private var followManager: UserFollowManager
    
    private var postManager: PostManager
    
    public override init() {
        user = User()
        posts = []
        books = []
        followed = false
        userBookManager = UserBookManager.shared
        userManager = UserManager()
        followManager = UserFollowManager()
        postManager = PostManager()
        
        super.init()
        observerUserBookInfo()
        observerUserInfo()
        observerUserFollow()
        observerNewestPosts()
    }
    
    /// Fetching data from Server to fill page if it passed bookID from preView
    public func prepareData(uid: String?) {
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
        
        self.books = []
        self.posts = []
        userBookManager.getUserBooks(uid: uid ?? self.user.id)
        postManager.getPersonalNewestPosts(page: 0, uid: uid ?? self.user.id)
    }
    
    func processFollow() {
        if followed == true {
            // make unfollow request
            followManager.unfollow(followerId: AppManager.shared.currenUID, targetId: user.id)
        } else {
            // make follow
            let follow = EUserfollow(uid: user.id, followerId: AppManager.shared.currenUID)
            followManager.makeFollow(follow: follow)
        }
        
        followed = !followed
        self.objectWillChange.send()
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
                    
                    if !ubs.isEmpty {
                        
                        ubs.forEach { (ub) in
                            
                            let userBook = BUserBook(
                                ubid: ub.id!,
                                uid: ub.userID!,
                                status: ub.status,
                                title: ub.title!,
                                author: ub.author!,
                                state: ub.state,
                                cover: ub.cover
                            )
                            self.books.appendUnique(item: userBook)
                        }
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
                    
                    if u.id == "undefine" {
                        self.resourceInfo = .notfound
                        self.showAlert.toggle()
                    } else {
                        self.user = User(
                            id: u.id!,
                            username: "unknow",
                            displayname: u.displayname,
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

                    if uf.id == "undefine" || uf.id == nil {
                        self.followed = false
                    } else {
                        self.followed = true
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
