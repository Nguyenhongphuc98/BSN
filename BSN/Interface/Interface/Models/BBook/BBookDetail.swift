//
//  BBookDetail.swift
//  Interface
//
//  Created by Phucnh on 10/28/20.
//

import SwiftUI

class BBookDetail: BBook {
    
    var numReading: Int
    
    var numAvailable: Int
    
    var ratingCriteria: RatingCriteria
    
    override init() {
        numReading = 10
        numAvailable = 20
        ratingCriteria = RatingCriteria()
        super.init()
    }
}
