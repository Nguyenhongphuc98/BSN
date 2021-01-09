//
//  ENote.swift
//  Business
//
//  Created by Phucnh on 10/31/20.
//

public class ENote: Codable {
    
    public var id: String?
    public var userBookID: String?
    public var content: String
    public var createdAt: String?
    
    public var pageRef: String?
    public var photo: String?
    
    public init() {
        id = "undefine"
        userBookID = ""
        content = ""
        createdAt = ""
    }
    
    public init(id: String? = nil, userBookID :String? = nil,
                content :String, createdAt: String? = nil, page: String? = nil, photo: String? = nil) {
        self.id = id
        self.userBookID = userBookID
        self.content = content
        self.createdAt = createdAt
        self.pageRef = page
        self.photo = photo
    }
}
