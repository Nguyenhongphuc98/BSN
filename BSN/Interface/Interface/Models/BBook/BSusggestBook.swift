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
}
