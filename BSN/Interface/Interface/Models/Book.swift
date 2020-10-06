//
//  Book.swift
//  Interface
//
//  Created by Phucnh on 10/5/20.
//

import SwiftUI

// MARK: - Book state and status
enum BookState {
    case borrowed
    case available //to be borrowed
    case reading
    case unknown
}

enum BookStatus: String, CaseIterable {
    case new
    case likeNew
    case old
    case veryOld
}

// MARK: - Book model
// Model in explore card
class Book: Identifiable {
    
    var id: String
    
    var name: String
    
    var author: String
    
    var rating: Float
    
    var numReview: Int
    
    var photo: String
    
    init() {
        id = UUID().uuidString
        name = "Bứt phá để thành công"
        author = "Nguyễn Hồng Phúc"
        rating = 4.5
        numReview = 7
        photo = "book"
    }
}
