//
//  BSusggestBook.swift
//  Interface
//
//  Created by Phucnh on 10/27/20.
//

import SwiftUI

class BSusggestBook: BBook {
    
    var avgRating: Float
    
    var numReview: Int
    
    override init() {
        avgRating = 3.5
        numReview = 10
        super.init()
    }
    
    init(id: String, title: String, author: String, cover: String?, avgRating: Float, numReview: Int) {
        self.avgRating = avgRating
        self.numReview = numReview
        
        super.init()
        self.id = id
        self.title = title
        self.author = author
        self.cover = cover ?? "book_cover"
    }
}
