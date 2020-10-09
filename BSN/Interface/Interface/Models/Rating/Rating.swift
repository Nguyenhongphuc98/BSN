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
    
    var authorID: String
    
    var title: String
    
    var rating: Float
    
    var content: String
    
    var createDate: Date
    
    var ratingBookID: String
    
    init() {
        id = UUID().uuidString
        authorPhoto = randomAvatar()
        authorID = UUID().uuidString
        title = "Sách hay nên đọc"
        rating = 4.3
        content = randomComment()
        createDate = randomDate()
        ratingBookID = UUID().uuidString
    }
    
    init(authorPhoto: String, authorID: String, title: String, rating: Float, content: String, bookID: String) {
        self.id = UUID().uuidString
        self.authorID = authorID
        self.authorPhoto = authorPhoto
        self.title = title
        self.rating = rating
        self.content = content
        self.createDate = Date()
        self.ratingBookID = bookID
        
        // ReCheck title
        self.title = genrateAutoTitle(title: title)
    }
    
    func genrateAutoTitle(title: String) -> String {
        guard title.isEmpty else {
            return title
        }
        
        if rating == 5 {
            return "Rất hài lòng"
        }
        else if rating >= 4 {
            return "Hài lòng"
        }
        else if rating >= 2.5 {
            return " Bình thường"
        }
        else if rating >= 2 {
            return "Không hài lòng"
        } else {
            return "Rất không Hài lòng"
        }
    }
}
