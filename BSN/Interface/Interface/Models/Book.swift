//
//  Book.swift
//  Interface
//
//  Created by Phucnh on 10/5/20.
//

import SwiftUI

class Book: Identifiable {
    
    var id: String
    
    var name: String
    
    var author: String
    
    var rating: Float
    
    var numReview: Int
    
    var photo: String
    
    init() {
        id = UUID().uuidString
        name = "Bứt phá để cho vui"
        author = "Nguyễn Hồng Phúc"
        rating = 4.5
        numReview = 7
        photo = "book"
    }
}
