//
//  Book.swift
//  Business
//
//  Created by Phucnh on 10/26/20.
//

public struct EBook: Codable {
    
    public var id: String?
    
    public var title: String
    
    public var author: String
    
    public var cover:  String?
    
    public var description: String?
    
    public var categoryID: String?
 
    public var isbn: String
 
    public var avgRating: Float?
  
    public var writeRating: Float?
    
    public var characterRating: Float?
    
    public var targetRating: Float?
    
    public var infoRating: Float?
    
    public var confirmed: Bool?
    
    public var createdAt: String?
    
    public var numReview: Int?
    
    // Addition
    public var numReading: Int?
    
    public var numAvailable: Int?
    
    public init() {
        title = ""
        author = ""
        isbn = ""
    }
    
    public init(title: String, author: String, isbn: String, cover: String? = nil, des: String? = nil, categoryId: String? = nil) {
        self.title = title
        self.author = author
        self.cover = cover
        self.description = des
        self.isbn = isbn
        // Default category is Undefine have ID as bellow
        self.categoryID = categoryID ?? "59EB6BBF-1C9A-44CB-A680-D09416248485"
    }
}
