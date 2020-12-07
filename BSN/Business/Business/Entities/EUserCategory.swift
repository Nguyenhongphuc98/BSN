//
//  EUserCategory.swift
//  Business
//
//  Created by Phucnh on 12/6/20.
//

public struct EUserCategory: Codable {
    
    public var userID: String
    public var categoryID: String
    public var categoryName: String?
    public var isInterested: Bool?
    
    public init(userID: String, categoryID: String) {
        self.userID = userID
        self.categoryID = categoryID        
    }
}
