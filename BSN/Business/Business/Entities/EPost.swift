//
//  EPost.swift
//  Business
//
//  Created by Phucnh on 11/23/20.
//

public struct EPost: Codable {
    
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
    public var authorName: String?
    public var categoryName: String?
    
    public var isHeart: Bool?
    
    init() {
        
        self.id = "undefine"
        self.categoryID = "undefine"
        self.authorID = "undefine"
        self.content = "undefine"
    }
    
    public init(id: String? = nil, categoryID: String, authorID: String, quote: String? = nil, content: String, photo: String? = nil) {
        
        self.id = id
        self.categoryID = categoryID
        self.authorID = authorID
        self.quote = quote
        self.content = content
        self.photo = photo
    }
}
