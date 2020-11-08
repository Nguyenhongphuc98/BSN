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
    
    override init() {
        numReading = 0
        numAvailable = 0
        ratingCriteria = RatingCriteria()
        super.init()
    }
    
    init(book: EBook) {
        numReading = book.numReading ?? 0
        numAvailable = book.numAvailable ?? 0
        ratingCriteria = RatingCriteria()
        super.init()
        
        ratingCriteria.writing = book.writeRating ?? 0
        ratingCriteria.target = book.targetRating ?? 0
        ratingCriteria.character = book.characterRating ?? 0
        ratingCriteria.info = book.infoRating ?? 0
        
        title = book.title
        author = book.author
        cover = book.cover
        description = book.description
    }
}
