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
    
    public var statusDes: String
    
    public var createdAt: String?
    
    public init() {
        userID = ""
        bookID = ""
        state = ""
        status = ""
        statusDes = ""
    }
    
    public init(id: String? = nil, uid: String, bid: String, status: String, state: String, statusDes: String, createdAt: String? = nil) {
        self.id = id
        self.userID = uid
        self.bookID = bid
        self.status = status
        self.state = state
        self.statusDes = statusDes
        self.createdAt = createdAt
    }
}
