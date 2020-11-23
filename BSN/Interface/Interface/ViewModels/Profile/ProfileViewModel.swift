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
    
    public override init() {
        user = User()
        posts = fakeNews
        books = []
        followed = false
        userBookManager = UserBookManager.shared
        userManager = UserManager()
        followManager = UserFollowManager()
        
        super.init()
        setupReceiveUserBookInfo()
        observerUserInfo()
        observerUserFollow()
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
        
        userBookManager.getUserBooks(uid: uid ?? self.user.id)
    }
    
    /// UserBook get from server  will received at this block
    private func setupReceiveUserBookInfo() {
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
                        
                        self.books = []
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
                            self.books.append(userBook)
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
}
