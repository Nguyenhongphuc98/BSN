//
//  BUserBook.swift
//  Interface
//
//  Created by Phucnh on 10/27/20.
//

import SwiftUI

class BUserBook: BBook {
    
    var ownerName: String?
    var ownerID: String?
    var bookID: String
    
    @Published var status: BookStatus?
    @Published var state: BookState?
    
    var statusDes: String
    
    override init() {
        ownerName = "Nguyễn Hồng Phúc"
        ownerID = UUID().uuidString
        status = .likeNew
        state = .available
        statusDes = ""
        bookID = ""
        super.init()
    }
    
    init(ubid: String, uid: String, status: String = "new", title: String, author: String, state: String = "available", cover: String? = nil) {
        self.status = .new
        self.state = .available
        self.statusDes = ""
        self.bookID = ""
        
        super.init()
        
        self.id = ubid
        self.ownerID = uid
        self.status = BookStatus(rawValue: status) ?? .new
        self.state = BookState(rawValue: state) ?? . available
        self.title = title
        self.author = author
        self.cover = cover ?? "book_cover"
    }
    
    init(ubid: String? = nil, bookID: String = "", uid: String? = nil, ownerName: String? = nil, status: String? = nil, title: String, author: String, state: String? = nil, cover: String? = nil, des: String? = nil) {
        
        self.ownerID = uid
        self.ownerName = ownerName
        self.status = BookStatus(rawValue: status ?? "new")
        self.state = BookState(rawValue: state ?? "available")
        self.statusDes = des ?? "Không có mô tả tình trạng"
        self.bookID = bookID
        
        super.init()
        
        self.id = ubid
        self.title = title
        self.author = author
        self.cover = cover ?? "book_cover"
        
        if self.statusDes == "" {
            self.statusDes = "Không có mô tả tình trạng"
        }
    }
}
