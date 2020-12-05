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
    
    // in case create new account
    public var name: String?
    public var confirmPassword: String?
    
    public init() {
        id = "undefine"
        username = "undefine"
        password = "undefine"
        isOnboarded = false
    }
    
    public init(id: String? = nil,name: String? = nil, username: String, password: String, confirmPass: String? = nil, isOnboarded: Bool = false) {
        
        self.id = id
        self.name = name
        self.username = username
        self.password = password
        self.confirmPassword = confirmPass
        self.isOnboarded = isOnboarded
    }
}
