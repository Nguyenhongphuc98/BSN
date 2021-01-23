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
    
    // Load more message
    @Published var isLoadmore: Bool
    @Published var allNewsFetched: Bool
    @Published var currentPage: Int
    
    private var postManager: PostManager
    
    public static var shared: NewsFeedViewModel = .init()
    
    override init() {
        newsData = []
        isLoadmore = false
        allNewsFetched = false
        currentPage = 0
        postManager = PostManager()
        
        super.init()
        observerNewestPosts()
        prepareData()
    }
    
    public func prepareData() {
        // load newest posts at page 0
        isLoading = true
        currentPage = 0
        newsData = []
        allNewsFetched = false
        postManager.getNewestPosts(page: 0)
    }
    
    func deletePost(pid: String) {
        willDeletePost(pid: pid)
        ProfileViewModel.shared.willDeletePost(pid: pid)
        postManager.deletePost(postID: pid)
    }
    
    func willDeletePost(pid: String) {
        guard let index = newsData.firstIndex(where: { $0.id == pid }) else {
            return
        }
        
        withAnimation {
            _ = newsData.remove(at: index)
            objectWillChange.send()
        }
    }
    
    func loadMoreIfNeeded(item: NewsFeed) {
        guard !allNewsFetched else {
            print("All news fetched. break fetching func...")
            return
        }
        let thresholdIndex = newsData.count - 1
        if newsData.firstIndex(where: { $0.id == item.id }) == thresholdIndex {
            currentPage += 1
            isLoadmore = true
            postManager.getNewestPosts(page: currentPage)
        }
    }
    
    func addNewPostToTop(news: NewsFeed) {
        DispatchQueue.main.async {
            self.newsData.insertUnique(item: news)
            self.objectWillChange.send()
        }
    }
    
    // when profile action on post, newfeed shoud change too
    func postDidChange(post: NewsFeed) {
        let index = self.newsData.firstIndex(of: post)
        if index == nil {
            return
        }
        self.newsData[index!].clone(from: post)
        self.newsData[index!].objectWillChange.send()
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
                    self.isLoadmore = false
                    
                    posts.forEach { p in
                        let newfeed = NewsFeed(post: p)
                        self.newsData.appendUnique(item: newfeed)
                    }
                    
                    // num of news < config shoud be last page
                    if posts.count < BusinessConfigure.newestPostsPerPage {
                        self.allNewsFetched = true
                    }
                    self.objectWillChange.send()
                }
            }
            .store(in: &cancellables)
    }
}
