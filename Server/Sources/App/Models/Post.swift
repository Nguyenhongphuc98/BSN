//
//  Post.swift
//  
//
//  Created by Phucnh on 10/18/20.
//

import Fluent
import Vapor

final class Post: Model {
    
    static let schema = "post"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "category_id")
    var categoryID: Category.IDValue
    
    @Field(key: "author_id")
    var authorID: User.IDValue
    
    @Field(key: "quote")
    var quote:  String?
    
    @Field(key: "content")
    var content: String
    
    @Field(key: "photo")
    var photo: String?
    
    @OptionalField(key: "num_heart")
    var numHeart: Int?
    
    @OptionalField(key: "num_break_heart")
    var numBreakHeart: Int?
    
    @OptionalField(key: "num_comment")
    var numComment: Int?
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    init() { }
}

extension Post: Content { }


extension Post {
    struct GetFull: Content {
        public var id: String?
        public var categoryID: String
        public var authorID: String
        public var quote:  String?
        public var content: String
        public var photo: String?
        public var numHeart: Int?
        public var numBreakHeart: Int?
        public var numComment: Int?
        public var createdAt: String?
        
        public var authorPhoto: String?
        public var authorName: String
        public var categoryName: String
    }
}
