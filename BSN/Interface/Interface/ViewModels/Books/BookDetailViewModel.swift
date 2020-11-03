//
//  BookDetailViewModel.swift
//  Interface
//
//  Created by Phucnh on 10/5/20.
//

import SwiftUI
import Business

class BookDetailViewModel: NetworkViewModel {
    
    var model: BBookDetail
    
    var reviews: [Rating]
    
    private var bookReviewManager: BookReviewManager
    
    override init() {
        model = BBookDetail()
        reviews = []
        bookReviewManager = BookReviewManager()
        
        super.init()
        setupReceiveReivews()
    }
    
    func prepareData(bid: String) {
        isLoading = true
        // load core book info
        //load reivew
        model.id = bid
        bookReviewManager.getReviews(bid: bid)
    }
    
    func addNewRating(rate: Rating) {
        // Update UI with new rating
        reviews.append(rate)
    }
    
    private func setupReceiveReivews() {
        /// Get save user_book
        bookReviewManager
            .getReviewsPublisher
            .sink {[weak self] (brs) in
                
                guard let self = self else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.isLoading = false
                    
                    if !brs.isEmpty {
                        brs.forEach { (br) in
                            let model = Rating(
                                authorPhoto: br.avatar!,
                                authorID: br.userID!,
                                title: br.title,
                                rating: br.avgRating,
                                content: br.description!,
                                bookID: br.bookID!
                            )
                            self.reviews.appendUnique(item: model)
                        }
                    }
                    self.isLoading = false
                }
            }
            .store(in: &cancellables)
    }
}
