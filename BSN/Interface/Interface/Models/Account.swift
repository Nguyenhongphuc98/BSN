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
    
    public init() {
        username = ""
        password = ""
    }
    
    public init(id: String? = nil, username: String, password: String) {
        self.id = id
        self.username = username
        self.password = password
    }
}
