//
//  BookDetailViewModel.swift
//  Interface
//
//  Created by Phucnh on 10/5/20.
//

import SwiftUI
import Business

class BookDetailViewModel: ObservableObject {
    
    var model: BBookDetail
    
    var reviews: [Rating]
    
    private var bookReviewManager: BookReviewManager
    
    init() {
        model = BBookDetail()
        reviews = []
    }
    
    func addNewRating(rate: Rating) {
        // Update UI with new rating
        reviews.append(rate)
    }
}
