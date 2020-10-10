//
//  NewsFeedViewModel.swift
//  Interface
//
//  Created by Phucnh on 9/29/20.
//

import SwiftUI

class NewsFeedViewModel: ObservableObject {
    
    // Loading new news when sroll to last news
    @Published  var isLoadingNews: Bool
    
    @Published var newsData: [NewsFeed]
    
    init() {
        isLoadingNews = false
        newsData = fakeNews
    }
    
    func loadMoreIfNeeded(item: NewsFeed) {
        let thresholdIndex = newsData.index(newsData.endIndex, offsetBy: -2)
        if newsData.firstIndex(where: { $0.id == item.id }) == thresholdIndex {
            print("reached \(item.id)")
            self.isLoadingNews = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                for _ in 1...7 {
                    self.newsData.append(NewsFeed())
                }
                self.isLoadingNews = false
                print("total news: \(self.newsData.count)")
            }
        }
    }
}
