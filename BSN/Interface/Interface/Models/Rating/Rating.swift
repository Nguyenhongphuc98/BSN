//
//  Rating.swift
//  Interface
//
//  Created by Phucnh on 10/5/20.
//

import SwiftUI

// Model in review book view
class Rating: AppendUniqueAble, ObservableObject {
    
    var id: String
    var title: String
    var content: String
    var createDate: Date
    
    var authorPhoto: String
    var authorID: String
    
    var ratingBookID: String
    
    var writeRating: Int
    var characterRating: Int
    var targetRating: Int
    var infoRating: Int
    var avgRating: Float
    
    init() {
        id = kUndefine
        title = ""
        content = ""
        createDate = Date()
        
        authorPhoto = fakeAvatars.randomElement()!
        authorID = kUndefine
        
        ratingBookID = kUndefine
        
        writeRating = 0
        characterRating = 0
        targetRating = 0
        infoRating = 0
        avgRating = 0
    }
    
    init(id: String? = nil, authorPhoto: String, authorID: String,
         title: String, character: Int, write: Int, target: Int,
         info: Int, rating: Float, content: String, bookID: String,
         createAt: String? = nil) {

        self.id = id ?? "undefine"
        self.authorID = authorID
        self.authorPhoto = authorPhoto
        self.title = title
        
        self.content = content
        //self.createDate = Date()
        self.ratingBookID = bookID
        self.createDate = Date.getDate(dateStr: createAt)
        
        self.writeRating = write
        self.characterRating = character
        self.targetRating = target
        self.infoRating = info
        self.avgRating = rating
        
        // ReCheck title
        self.title = genrateAutoTitle(title: title)
    }
    
    func clone(other: Rating) {

        self.id = other.id
        self.authorID = other.authorID
        self.authorPhoto = other.authorPhoto
        self.title = other.title
        
        self.content = other.content
        self.ratingBookID = other.ratingBookID
        self.createDate = other.createDate
        
        self.writeRating = other.writeRating
        self.characterRating = other.characterRating
        self.targetRating = other.targetRating
        self.infoRating = other.infoRating
        self.avgRating = other.avgRating
    }
    
    func genrateAutoTitle(title: String) -> String {
        guard title.isEmpty else {
            return title
        }
        
        if avgRating == 5 {
            return "Rất hài lòng"
        }
        else if avgRating >= 4 {
            return "Hài lòng"
        }
        else if avgRating >= 2.5 {
            return " Bình thường"
        }
        else if avgRating >= 2 {
            return "Không hài lòng"
        } else {
            return "Rất không Hài lòng"
        }
    }
    
    func clear() {
        id = kUndefine
        title = ""
        content = ""
        createDate = Date()
        
        authorPhoto = fakeAvatars.randomElement()!
        authorID = kUndefine
        
        ratingBookID = kUndefine
        
        writeRating = 0
        characterRating = 0
        targetRating = 0
        infoRating = 0
        avgRating = 0
    }
}
