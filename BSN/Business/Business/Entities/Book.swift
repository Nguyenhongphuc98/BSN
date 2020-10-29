//
//  Book.swift
//  Business
//
//  Created by Phucnh on 10/26/20.
//

public struct Book: Codable {
    
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
    
    init() {
        title = ""
        author = ""
        isbn = ""
    }
    
    public init(title: String, author: String, isbn: String, cover: String? = nil, des: String? = nil) {
        self.title = title
        self.author = author
        self.cover = cover
        self.description = des
        self.isbn = isbn
        // Default category is Undefine have ID as bellow
        self.categoryID = "59EB6BBF-1C9A-44CB-A680-D09416248485"
    }
}
