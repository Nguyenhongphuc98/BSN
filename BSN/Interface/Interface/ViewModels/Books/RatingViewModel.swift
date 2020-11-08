//
//  RatingViewModel.swift
//  Interface
//
//  Created by Phucnh on 10/6/20.
//

import SwiftUI
import Business

// View model for rating view
class RatingViewModel: NetworkViewModel {
    
    var rating: RatingCriteria
    
    // short des review
    @Published var title: String
    
    private var bookReviewManager: BookReviewManager
    
    override init() {
        rating = RatingCriteria()
        title = ""
        bookReviewManager = BookReviewManager()
        
        super.init()
        observerChangeBookReview()
    }
    
    func didRating(message: String, bookID: String) {
        
        let uid = AppManager.shared.currentUser.id
        let ebr = EBookReview(
            userID: uid,
            bookID: bookID,
            title: title,
            description: message,
            writeRating: Int(rating.writing),
            characterRating: Int(rating.character),
            targetRating: Int(rating.target),
            infoRating: Int(rating.info)
        )
        
        bookReviewManager.saveReview(review: ebr)
    }
    
    /// Using for Add Bookreview View, create a review
    private func observerChangeBookReview() {
        bookReviewManager
            .changePublisher
            .sink {[weak self] (br) in
                
                guard let self = self else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.isLoading = false
                    
                    if br.id == "undefine" {
                        self.resourceInfo = .savefailure
                    } else {
                        
                        self.resourceInfo = .success
                    }
                    self.showAlert = true
                }
            }
            .store(in: &cancellables)
    }
}
