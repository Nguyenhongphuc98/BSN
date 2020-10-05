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
    
    // Giong van cuon hut
    var writingRate: Float
    
    // Muc dich ro rang
    var targetRate: Float
    
    // Nhan vat loi cuon
    var characterRate: Float
    
    // thong tin huu ich
    var infoRate: Float
    
    var description: String
    
    override init() {
        numReading = 10
        numAvailable = 20
        writingRate = 4.5
        targetRate = 5
        characterRate = 3.5
        infoRate = 4
        description = randomComment()
    }
}
