//
//  User.swift
//  BSN
//
//  Created by Phucnh on 9/23/20.
//

import Foundation

public class User {

    public var username: String

    public var displayname: String

    public var avatar: String

    public var gender: Gender

    public init() {
        username = "phucnh@gmail.com"
        displayname = "Nguyễn Phúc Thiên Kim"
        avatar = "avatar"
        gender = .male
    }
}

public enum Gender {

    case male

    case female

    case other

    case unknown
}
