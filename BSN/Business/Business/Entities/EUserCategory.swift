//
//  EUserCategory.swift
//  Business
//
//  Created by Phucnh on 12/6/20.
//

public struct EUserCategory: Codable {
    
    public var userID: String
    public var categoryID: String
    public var categoryName: String
    public var isInterested: Bool
    
    init(userID: String, categoryID: String, categoryName: String, interested: Bool) {
        self.userID = userID
        self.categoryID = categoryID
        self.categoryName = categoryName
        self.isInterested = interested
    }
}
