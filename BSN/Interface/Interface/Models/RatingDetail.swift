//
//  RatingDetail.swift
//  Interface
//
//  Created by Phucnh on 10/6/20.
//

import SwiftUI

// Using for rating detail view
class RatingDetail: Rating {
    
    var ratingCriteria: RatingCriteria
    
    override init() {
        ratingCriteria = RatingCriteria()
        super.init()
    }
    
    init(authorPhoto: String, authorID: String, title: String, rating: Float, content: String, bookID: String, ratingCriteria: RatingCriteria) {
        self.ratingCriteria = ratingCriteria
        super.init(authorPhoto: authorPhoto, authorID: authorID, title: title, rating: rating, content: content, bookID: bookID)
    }
}
