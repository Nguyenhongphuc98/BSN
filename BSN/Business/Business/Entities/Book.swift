//
//  Book.swift
//  Business
//
//  Created by Phucnh on 10/26/20.
//

public struct Book: Codable {
    
    public var id: UUID?
    
    public var title: String
    
    public var author: String
    
    public var cover:  String?
    
    public var description: String?
    
    public var categoryID: UUID?
 
    public var isbn: String
 
    public var avgRating: Float?
  
    public var writeRating: Float?
    
    public var characterRating: Float?
    
    public var targetRating: Float?
    
    public var infoRating: Float?
    
    public var confirmed: Bool?
    
    public var createdAt: Date?
    
    init() {
        title = ""
        author = ""
        isbn = ""
    }
}
