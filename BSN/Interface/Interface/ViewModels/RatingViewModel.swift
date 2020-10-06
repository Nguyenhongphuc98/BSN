//
//  RatingViewModel.swift
//  Interface
//
//  Created by Phucnh on 10/6/20.
//

import SwiftUI

// View model for rating view
class RatingViewModel: ObservableObject {
    
    var rating: RatingCriteria
    
    // short des review
    @Published var title: String
    
    init() {
        rating = RatingCriteria()
        title = ""
    }
    
    func didRating(message: String, bookID: String, complete: @escaping (Rating) -> Void) {
        
        // rating to show
        let rating = Rating(
            authorPhoto: AppManager.shared.currentUser.avatar,
            authorID: AppManager.shared.currentUser.id,
            title: title,
            rating: self.rating.avg,
            content: message,
            bookID: bookID
        )
        
        // To -Do
        // Call BL to save rating detail
        
        complete(rating)
    }
}
