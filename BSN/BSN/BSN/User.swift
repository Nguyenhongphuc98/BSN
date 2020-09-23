//
//  User.swift
//  BSN
//
//  Created by Phucnh on 9/23/20.
//

import Foundation

class User {
    
    var username: String
    
    var displayname: String
    
    var avatar: String
    
    var gender: Gender
    
    init() {
        username = "phucnh@gmail.com"
        displayname = "Hồng Phúc"
        avatar = "avatar"
        gender = .male
    }
}

enum Gender {
    
    case male
    
    case female
    
    case other
    
    case unknown
}
