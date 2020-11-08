//
//  EBookReview.swift
//  Business
//
//  Created by Phucnh on 11/3/20.
//

public struct EBookReview: Codable {
    
    public var id: String?
    
    public var userID: String?
    
    public var bookID: String?
    
    public var title: String
    
    public var description: String?
    
    public var writeRating: Int
    
    public var characterRating: Int
    
    public var targetRating: Int
    
    public var infoRating: Int
    
    public var createdAt: String?
    
    // Addition part
    public var avatar: String?
    
    public var avgRating: Float {
        Float(Float(writeRating + characterRating + targetRating + infoRating) / 4.0)
    }
    
    public init() {
        id = "undefine"
        title = "Tiêu đề sách"
        writeRating = 0
        characterRating = 0
        targetRating = 0
        infoRating = 0
    }
    
    public init(id: String? = nil, userID: String? = nil, bookID: String? = nil, title: String, description: String? = nil, writeRating: Int = 5, characterRating: Int = 5, targetRating: Int = 5, infoRating: Int = 5, createdAt: String? = nil, avatar: String? = nil) {
        
        self.id = id
        self.userID = userID
        self.bookID = bookID
        self.title = title
        self.description = description
        self.writeRating = writeRating
        self.characterRating = characterRating
        self.targetRating = targetRating
        self.infoRating = infoRating
        self.createdAt = createdAt
        self.avatar = avatar
    }
}
