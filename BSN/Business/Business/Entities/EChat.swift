//
//  EChat.swift
//  Business
//
//  Created by Phucnh on 11/14/20.
//

public struct EChat: Codable {
    
    public var id: String?
    public var firstUserID: String
    public var secondUserID: String
    public var firstUserSeen: Bool?
    public var secondUserSeen: Bool?
    
    // User info
    public var firstUserName: String?
    public var firstUserPhoto: String?
    public var secondUserName: String?
    public var secondUserPhoto: String?
    
    // Last message
    public var messageContent: String?
    public var messageCreateAt: String?
    public var messageTypeName: String?
        
    public init() {
        self.id = "undefine"
        self.firstUserID = "undefine"
        self.secondUserID = "undefine"
    }
    
    public func getPartnerID(of uid: String) -> String {
        (self.firstUserID == uid) ? self.secondUserID : self.firstUserID
    }
    
    public func getPartnerName(of uid: String) -> String {
        (self.firstUserID == uid) ? self.secondUserName! : self.firstUserName!
    }
    
    public func getPartnerPhoto(of uid: String) -> String? {
        (self.firstUserID == uid) ? self.secondUserPhoto : self.firstUserPhoto
    }
    
    public func isSeen(of uid: String) -> Bool {
        (self.firstUserID == uid) ? self.firstUserSeen! : self.secondUserSeen!
    }
}
