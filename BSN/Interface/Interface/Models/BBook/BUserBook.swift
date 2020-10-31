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
    
    var status: BookStatus
    
    var state: BookState
    
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
}
