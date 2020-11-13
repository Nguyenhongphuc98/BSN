//
//  ENotify.swift
//  Business
//
//  Created by Phucnh on 11/12/20.
//

public struct ENotify: Codable {
    
    public var id: String
    public var notifyTypeID: String
    public var actorID: String
    public var receiverID: String
    public var destionationID: String
    public var seen: Bool
    public var createdAt: String?
    
    public var actorName: String?
    public var actorPhoto: String?
    public var notifyName: String?
        
    public init() {
        self.id = "undefine"
        self.notifyTypeID = "undefine"
        self.actorID = "undefine"
        self.receiverID = "undefine"
        self.destionationID = "undefine"
        self.seen = false
        self.createdAt = "undefine"
        self.actorName = "undefine"
        self.notifyName = "undefine"
    }
    
    // using for update seen
    public init(id: String, seen: Bool) {
        self.id = id
        self.notifyTypeID = "undefine"
        self.actorID = "undefine"
        self.receiverID = "undefine"
        self.destionationID = "undefine"
        self.seen = seen
        self.createdAt = "undefine"
        self.actorName = "undefine"
        self.notifyName = "undefine"
    }
}
