//
//  BookDetailViewModel.swift
//  Interface
//
//  Created by Phucnh on 10/5/20.
//

import SwiftUI

class BookDetailViewModel: ObservableObject {
    
    var model: BBookDetail
    
    var reviews: [Rating]
    
    init() {
        model = BBookDetail()
        reviews = [Rating(), Rating()]
    }
    
    func addNewRating(rate: Rating) {
        // Update UI with new rating
        reviews.append(rate)
    }
}
