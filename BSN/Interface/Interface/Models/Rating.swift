//
//  Rating.swift
//  Interface
//
//  Created by Phucnh on 10/5/20.
//

import SwiftUI

// Model in review book view
class Rating: Identifiable {
    
    var id: String
    
    var authorPhoto: String
    
    var authorId: String
    
    var title: String
    
    var rating: Float
    
    var content: String
    
    var createDate: Date
    
    init() {
        id = UUID().uuidString
        authorPhoto = randomAvatar()
        authorId = UUID().uuidString
        title = "Sách hay nên đọc"
        rating = 4.3
        content = randomComment()
        createDate = randomDate()
    }
}
