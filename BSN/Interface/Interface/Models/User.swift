//
//  User.swift
//  BSN
//
//  Created by Phucnh on 9/23/20.
//

import Foundation

public class User: ObservableObject, Identifiable {
    
    public var id: String

    public var username: String

    public var displayname: String

    public var avatar: String

    public var gender: Gender

    public init() {
        id = UUID().uuidString
        username = UUID().uuidString
        displayname = fakeNames.randomElement()!
        avatar = fakeAvatars.randomElement()!
        gender = .male
    }
    
    public init(isDummy: Bool) {
        id = "Dummy"
        username = "Dummy"
        displayname = "Dummy"
        avatar = fakeAvatars.randomElement()!
        gender = .male
    }
    
    func isCurrentUser() -> Bool {
        return self.username == AppManager.shared.currentUser.username
    }
    
    func isDummt() -> Bool {
        id == "Dummy"
    }
}

public enum Gender {

    case male

    case female

    case other

    case unknown
}
