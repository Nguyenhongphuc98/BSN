//
//  BBookDetail.swift
//  Interface
//
//  Created by Phucnh on 10/28/20.
//

import SwiftUI
import Business

class BBookDetail: BBook {
    
    @Published var numReading: Int
    
    @Published var numAvailable: Int
    
    @Published var ratingCriteria: RatingCriteria
    
    // shoud be pulish rather combine property
    // then it will notify when it's change
    @Published var avgRating: Float
    
    override init() {
        numReading = 0
        numAvailable = 0
        ratingCriteria = RatingCriteria()
        avgRating = 0
        super.init()
    }
    
    init(book: EBook) {
        numReading = book.numReading ?? 0
        numAvailable = book.numAvailable ?? 0
        ratingCriteria = RatingCriteria()
        avgRating = 5
        super.init()
        
        ratingCriteria.writing = book.writeRating ?? 0
        ratingCriteria.target = book.targetRating ?? 0
        ratingCriteria.character = book.characterRating ?? 0
        ratingCriteria.info = book.infoRating ?? 0
        avgRating = ratingCriteria.avg
        
        id = book.id
        title = book.title
        author = book.author
        cover = book.cover
        description = book.description
    }
}
