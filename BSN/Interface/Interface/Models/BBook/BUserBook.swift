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
    
    var status: BookStatus?
    
    var state: BookState?
    
    var statusDes: String
    
    override init() {
        ownerName = "Nguyễn Hồng Phúc"
        ownerID = UUID().uuidString
        status = .likeNew
        state = .available
        statusDes = ""
        super.init()
    }
    
    init(ubid: String, uid: String, status: String, title: String, author: String, state: String, cover: String? = nil) {
        self.status = .new
        self.state = .available
        self.statusDes = ""
        
        super.init()
        
        self.id = ubid
        self.ownerID = uid
        self.status = BookStatus(rawValue: status) ?? .new
        self.state = BookState(rawValue: state) ?? . available
        self.title = title
        self.author = author
        self.cover = cover
    }
    
    init(ubid: String? = nil, uid: String? = nil, ownerName: String? = nil, status: String? = nil, title: String, author: String, state: String? = nil, cover: String? = nil, des: String? = nil) {
        
        self.ownerID = uid
        self.ownerName = ownerName
        self.status = BookStatus(rawValue: status ?? "new")
        self.state = BookState(rawValue: state ?? "available")
        self.statusDes = des ?? ""
        
        super.init()
        
        self.id = ubid
        self.title = title
        self.author = author
        self.cover = cover
    }
}
