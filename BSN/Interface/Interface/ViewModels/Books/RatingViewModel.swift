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
    var lastMessage: String
    
    private var bookReviewManager: BookReviewManager
    
    override init() {
        rating = RatingCriteria()
        title = ""
        lastMessage = ""
        bookReviewManager = BookReviewManager()
        
        super.init()
        observerChangeBookReview()
    }
    
    func setupIfNeeded(r: Rating) {
        if r.id == kUndefine {
            return
        }
        title = r.title
        rating.character = Float(r.characterRating)
        rating.writing = Float(r.writeRating)
        rating.info = Float(r.infoRating)
        rating.target = Float(r.targetRating)
    }
    
    func didRating(message: String, bookID: String, processRating: Rating) {
        
        let uid = AppManager.shared.currentUser.id
        var ebr = EBookReview(
            userID: uid,
            bookID: bookID,
            title: title,
            description: message,
            writeRating: Int(rating.writing),
            characterRating: Int(rating.character),
            targetRating: Int(rating.target),
            infoRating: Int(rating.info)
        )
        
        if processRating.id == kUndefine {
            // No rating passed, mean create new
            bookReviewManager.saveReview(review: ebr)
        } else {
            ebr.id = processRating.id
            bookReviewManager.updateReview(review: ebr)
        }
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
