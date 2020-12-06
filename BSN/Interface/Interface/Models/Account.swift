//
//  Account.swift
//  BSN
//
//  Created by Phucnh on 9/23/20.
//

import Foundation

public class Account {
    
    public var id: String?
    
    public var username: String
    
    public var password: String
    
    public var isOnboard: Bool
    
    public init() {
        username = ""
        password = ""
        isOnboard = false
    }
    
    public init(id: String? = nil, username: String, password: String, isOnboard: Bool) {
        self.id = id
        self.username = username
        self.password = password
        self.isOnboard = isOnboard
    }
}
