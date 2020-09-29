//
//  BookCategoryViewModel.swift
//  Interface
//
//  Created by Phucnh on 9/29/20.
//

import SwiftUI

class BookCategoryViewModel: ObservableObject {
    
    @Published var categories: [String]
    
    init() {
        categories = []
        fetchData()
    }
    
    func fetchData() {
        categories = fakeCategory
    }
}
