//
//  RatingCriteria.swift
//  Interface
//
//  Created by Phucnh on 10/6/20.
//

import SwiftUI

class RatingCriteria {
    
    // Giong van cuon hut
    var writing: Float

    // Muc dich ro rang
    var target: Float

    // Nhan vat loi cuon
    var character: Float

    // thong tin huu ich
    var info: Float
    
    var avg: Float {
        (writing + target + character + info) / 4
    }
    
    init() {
        writing = 0
        target = 0
        character = 0
        info = 0
    }
}
