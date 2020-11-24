//
//  EComment.swift
//  Business
//
//  Created by Phucnh on 11/24/20.
//

public struct EComment: Codable {
    
    public var id: String?
    public var userID: String
    public var postID: String
    public var parentID: String
    public var content: String
    public var createdAt: String?
    
    init() {
        
        self.id = "undefine"
        self.userID = "undefine"
        self.postID = "undefine"
        self.parentID = "undefine"
        self.content = "undefine"
    }
    
    public init(id: String? = nil, userID: String, postID: String, parentID: String, content: String) {
        
        self.id = id
        self.userID = userID
        self.postID = postID
        self.parentID = parentID
        self.content = content
    }
}
