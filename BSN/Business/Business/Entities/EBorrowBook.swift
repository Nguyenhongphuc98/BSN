//
//  EBorrowBook.swift
//  Business
//
//  Created by Phucnh on 11/9/20.
//

public struct EBorrowBook: Codable {
    
    public var id: String?
    
    public var userBookID: String?
    
    public var borrowerID: String?
    
    public var borrowDate:  String?
    
    public var borrowDays: Int?
    
    public var adress: String?
    
    public var message: String?
    
    public var statusDes: String?
    
    public var state: String?
    
    public var createdAt: String?
    
    public var updatedAt: String?
    
    init() {
        id = "undefine"
    }
    
    public init(id: String? = nil, userBookID: String? = nil, borrowerID: String? = nil, borrowDate:  Date? = nil, borrowDays: Int? = 0, adress: String? = nil, message: String? = nil, statusDes: String? = nil, state: String? = nil) {
        
        let isoformatter = ISO8601DateFormatter.init()
        
        self.id = id
        self.userBookID = userBookID
        self.borrowerID = borrowerID
        self.borrowDate = isoformatter.string(from: borrowDate!)
        self.borrowDays = borrowDays
        self.adress = adress
        self.message = message
        self.statusDes = statusDes
        self.state = state
    }
}
