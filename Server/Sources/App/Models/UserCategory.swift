//
//  UserCategory.swift
//  
//
//  Created by Phucnh on 10/18/20.
//

import Fluent
import Vapor

final class UserCategory: Model {
    
    static let schema = "user_category"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "user_id")
    var userID: User.IDValue
    
    @Field(key: "category_id")
    var categoryID: Category.IDValue
    
    init() { }
}

extension UserCategory: Content { }

extension UserCategory {
    struct GetFull: Content {
        
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
}
