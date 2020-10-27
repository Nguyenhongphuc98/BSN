//
//  BBook.swift
//  Interface
//
//  Created by Phucnh on 10/27/20.
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

// MARK: - Book models
class BBook: ObservableObject, Identifiable {
    
    var id: String?
    
    //var isbn: String
    
    var title: String
    
    var author: String
    
    var cover: String?
    
    var description: String?
    
    init(id: String?, title: String, author: String, cover: String? = nil, description: String? = nil) {
        self.id = id
        self.title = title
        self.author = author
        self.cover = cover
        self.description = description
    }
    
    init() {
        self.id = UUID().uuidString
        self.title = "Bứt phá để thành công"
        self.author = "Ks. Nguyễn Hồng Phúc"
        self.cover = "book_cover"
        self.description = "Đây là cốn sách nói về cuộc sống của 1 chàng trai xuất thân từ gia đình rất khó khăn, nhưng thông qua đó anh lại nhận ra được nhiều giá trị tự cuộc sống."
    }
}
