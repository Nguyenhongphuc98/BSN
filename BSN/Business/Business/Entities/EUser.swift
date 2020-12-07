//
//  EUser.swift
//  Business
//
//  Created by Phucnh on 11/11/20.
//

public struct EUser: Codable {
    
    public var id: String?
    
    public var displayname: String?
    
    public var avatar: String?
        
    public var cover: String?
    
    public var location: String?
        
    public var about: String?
        
    public var accountID: String?
        
    public var createdAt: String?
        
    public init() {
        self.displayname = "undefine"
        self.accountID = "undefine"
    }
    
    public init(id: String? = nil, displayname: String? = nil, avatar: String? = nil, cover: String? = nil, location: String? = nil, about: String? = nil, accountID: String? = nil) {
        
        self.id = id
        self.displayname = displayname
        self.avatar = avatar
        self.cover = cover
        self.location = location
        self.about = about
        self.accountID = accountID
    }
}
