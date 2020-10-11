//
//  BookDetail.swift
//  Interface
//
//  Created by Phucnh on 10/5/20.
//

import SwiftUI

// Model in box detail view
class BookDetail: Book {
    
    var numReading: Int
    
    var numAvailable: Int
    
    var ratingCriteria: RatingCriteria
    
    var description: String
    
    override init() {
        numReading = 10
        numAvailable = 20
        ratingCriteria = RatingCriteria()
        ratingCriteria.writing = 4.5
        ratingCriteria.target = 5
        ratingCriteria.character = 3.5
        ratingCriteria.info = 4
        description = fakeComments.randomElement()!
    }
}
