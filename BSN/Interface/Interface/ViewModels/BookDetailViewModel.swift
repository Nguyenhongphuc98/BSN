//
//  BookDetailViewModel.swift
//  Interface
//
//  Created by Phucnh on 10/5/20.
//

import SwiftUI

class BookDetailViewModel: ObservableObject {
    
    var model: BookDetail
    
    var reviews: [Rating]
    
    init() {
        model = BookDetail()
        reviews = [Rating(), Rating()]
    }
}
