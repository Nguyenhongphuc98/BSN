//
//  UserBook.swift
//  Business
//
//  Created by Phucnh on 10/26/20.
//

public struct UserBook: Codable {
    
    public var id: String?
    
    public var userID: String
    
    public var bookID: String
    
    public var status: String
    
    public var state: String
    
    public var statusDes: String?
    
    public var createdAt: String?
    
    // Additon part
    public var title: String?
    
    public var author: String?
    
    public var cover: String?
    
    public init() {
        userID = ""
        bookID = ""
        state = ""
        status = ""
        statusDes = ""
        title = ""
        author = ""
        cover = ""
    }
    
    public init(id: String? = nil, uid: String, bid: String, status: String, state: String, statusDes: String? = nil, createdAt: String? = nil, title: String, author: String, cover: String? = nil) {
        self.id = id
        self.userID = uid
        self.bookID = bid
        self.status = status
        self.state = state
        self.statusDes = statusDes
        self.createdAt = createdAt
        self.title = title
        self.author = author
        self.cover = cover
    }
}
