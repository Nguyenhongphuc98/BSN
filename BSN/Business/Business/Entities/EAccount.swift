//
//  EAccount.swift
//  Business
//
//  Created by Phucnh on 11/11/20.
//

public struct EAccount: Codable {
    
    public var id: String?
   
    public var username: String
    
    public var password: String
    
    public var isOnboarded: Bool
    
    public init() {
        id = "undefine"
        username = "undefine"
        password = "undefine"
        isOnboarded = false
    }
    
    public init(id: String? = nil, username: String, password: String, isOnboarded: Bool = false) {
        
        self.id = id
        self.username = username
        self.password = password
        self.isOnboarded = isOnboarded
    }
}
