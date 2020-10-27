//
//  Book.swift
//  Interface
//
//  Created by Phucnh on 10/5/20.
//

import SwiftUI

// MARK: - Book model
// Model in explore card
class Book: Identifiable, ObservableObject {

    var id: String

    @Published var name: String

    @Published var author: String

    var rating: Float

    var numReview: Int

    var photo: String

    init() {
        id = UUID().uuidString
        name = "Bứt phá để thành công"
        author = "Nguyễn Hồng Phúc"
        rating = 4.5
        numReview = 7
        photo = "book_cover"
    }

    init(id: String, name: String, author: String, photo: String?) {
        self.id = id
        self.name = name
        self.author = author
        rating = 0
        numReview = 0
        self.photo = photo ?? "book_cover"
    }
}
