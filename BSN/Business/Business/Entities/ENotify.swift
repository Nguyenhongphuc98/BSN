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
    public var createdAt: String?
    
    public var actorName: String
    public var actorPhoto: String?
    public var notifyName: String
        
    public init() {
        self.id = "undefine"
        self.notifyTypeID = "undefine"
        self.actorID = "undefine"
        self.receiverID = "undefine"
        self.destionationID = "undefine"
        self.createdAt = "undefine"
        self.actorName = "undefine"
        self.notifyName = "undefine"
    }
}
