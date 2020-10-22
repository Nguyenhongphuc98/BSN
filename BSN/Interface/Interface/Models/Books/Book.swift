//
//  Book.swift
//  Interface
//
//  Created by Phucnh on 10/5/20.
//

import SwiftUI

// MARK: - Book state and status
enum BookState: CaseIterable {
    case borrowed
    case available //to be borrowed
    case reading
    case exchanged
    case unknown
    
    func getTitle() -> String {
        switch self {
        case .available:
            return "Sẵn sàng cho mượn"
        case .borrowed:
            return "Đang cho mượn"
        case .reading:
            return "Đang đọc"
        case .exchanged:
            return "Đã trao đổi"
        case .unknown:
            return "Không xác định"
        }
    }
}

enum BookStatus: String, CaseIterable {
    case new
    case likeNew
    case old
    case veryOld
    
    func getTitle() -> String {
        switch self {
        case .new:
            return "Mới"
        case .likeNew:
            return "Như mới"
        case .old:
            return "Sách đã cũ"
        case .veryOld:
            return "Sách rất cũ"
        }
    }
    
    func getColor() -> Color {
        switch self {
        case .new:
            return ._primary
        case .likeNew:
            return .init(hex: 0x298DEA)
        case .old:
            return .init(hex: 0x05E744)
        case .veryOld:
            return .init(hex: 0xFF6D1B)
        }
    }
}

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
