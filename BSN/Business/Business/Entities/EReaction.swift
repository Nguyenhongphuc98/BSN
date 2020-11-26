//
//  EReaction.swift
//  Business
//
//  Created by Phucnh on 11/25/20.
//
public struct EReaction: Codable {
    
    public var id: String?
    public var userID: String
    public var postID: String
    public var isHeart: Bool
    public var createdAt: String?
    
    init() {
        
        self.id = "undefine"
        self.userID = "undefine"
        self.postID = "undefine"
        self.isHeart = true
    }
    
    public init(id: String? = nil, userID: String, postID: String, isHeart: Bool) {
        
        self.id = id
        self.userID = userID
        self.postID = postID
        self.isHeart = isHeart        
    }
}
