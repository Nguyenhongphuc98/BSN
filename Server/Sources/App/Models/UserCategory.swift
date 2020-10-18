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
