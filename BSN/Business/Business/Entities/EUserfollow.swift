//
//  EUserfollow.swift
//  Business
//
//  Created by Phucnh on 11/13/20.
//

public struct EUserfollow: Codable {
    
    public var id: String?
    
    public var userID: String?
    public var userName: String?
    public var userPhoto: String?
    
    public var followerID: String?
    public var followerName: String?
    public var followerPhoto: String?
        
    public init() {
        self.id = "undefine"
        self.userID = "undefine"
        self.userName = "undefine"
        self.userPhoto = "undefine"
        self.followerID = "undefine"
        self.followerName = "undefine"
        self.followerPhoto = "undefine"
    }
    
    // using for update seen
    public init(uid: String, followerId: String) {
        self.userID = uid
        self.followerID = followerId
    }
}
