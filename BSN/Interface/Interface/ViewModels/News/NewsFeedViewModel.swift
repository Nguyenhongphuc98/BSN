//
//  NewsFeedViewModel.swift
//  Interface
//
//  Created by Phucnh on 9/29/20.
//

import SwiftUI
import Business

public class NewsFeedViewModel: NetworkViewModel {
    
    @Published var newsData: [NewsFeed]
    
    private var postManager: PostManager
    
    public static var shared: NewsFeedViewModel = NewsFeedViewModel()
    
    override init() {
        newsData = []
        postManager = PostManager()
        
        super.init()
        observerNewestPosts()
        prepareData()
    }
    
    public func prepareData() {
        // load newest posts at page 0
        isLoading = true
        newsData = []
        postManager.getNewestPosts(page: 0)
    }
    
    func deletePost(pid: String) {
        guard let index = newsData.firstIndex(where: { $0.id == pid }) else {
            return
        }
        
        withAnimation {
            _ = newsData.remove(at: index)
            objectWillChange.send()
        }
        postManager.deletePost(postID: pid)
    }
    
    func loadMoreIfNeeded(item: NewsFeed) {
        let thresholdIndex = newsData.index(newsData.endIndex, offsetBy: -2)
        if newsData.firstIndex(where: { $0.id == item.id }) == thresholdIndex {
            print("reached \(item.id)")
            self.isLoading = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                for _ in 1...7 {
                    self.newsData.append(NewsFeed())
                }
                self.isLoading = false
                print("total news: \(self.newsData.count)")
            }
        }
    }
}

// MARK: - Observer
extension NewsFeedViewModel {
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
                        self.newsData.appendUnique(item: newfeed)
                    }
                }
            }
            .store(in: &cancellables)
    }
}
