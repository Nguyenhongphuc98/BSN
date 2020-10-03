//
//  User.swift
//  BSN
//
//  Created by Phucnh on 9/23/20.
//

import Foundation

public class User: ObservableObject {

    public var username: String

    public var displayname: String

    public var avatar: String

    public var gender: Gender

    public init() {
        username = UUID().uuidString
        displayname = randomName()
        avatar = randomAvatar()
        gender = .male
    }
    
    func isCurrentUser() -> Bool {
        return self.username == RootViewModel.shared.currentUser.username
    }
}

public enum Gender {

    case male

    case female

    case other

    case unknown
}
