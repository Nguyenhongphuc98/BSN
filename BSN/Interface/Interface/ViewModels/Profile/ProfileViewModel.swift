//
//  ProfileViewModel.swift
//  BSN
//
//  Created by Phucnh on 9/23/20.
//

import Foundation
import Business
import Combine

public class ProfileViewModel: ObservableObject {
    
    public static let shared: ProfileViewModel = ProfileViewModel()
    
    @Published var posts: [NewsFeed]
    
    @Published var books: [BUserBook]
    
    @Published var isLoading: Bool
    
    private var uid: String
    
    public var profile: Profile
    
    private var userBookManager: UserBookManager
    
    // Handle reslut process resource
    var resourceInfo: ResourceInfo
    
    var cancellables = Set<AnyCancellable>()
    
    public init() {
        profile = Profile()
        posts = fakeNews
        books = []
        uid = "undefine"
        userBookManager = UserBookManager.shared
        resourceInfo = .success
        isLoading = true
        
        setupReceiveUserBookInfo()
    }
    
    /// Fetching data from Server to fill page if it passed bookID from preView
    func prepareData(uid: String?) {
        self.uid = uid ?? AppManager.shared.currentUser.id
        userBookManager.getUserBooks(uid: self.uid)
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
                            
                            var userBook = BUserBook(
                                ubid: ub.id!,
                                uid: ub.userID,
                                status: ub.status,
                                title: ub.title!,
                                author: ub.author!,
                                state: ub.state
                            )
                            userBook.cover = ub.cover
                            self.books.append(userBook)
                        }
                    }
                }
            }
            .store(in: &cancellables)
    }
}
