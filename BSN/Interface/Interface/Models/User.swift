//
//  User.swift
//  BSN
//
//  Created by Phucnh on 9/23/20.
//

import Foundation

public class User: ObservableObject, Identifiable {
    
    public var id: String

    public var username: String?

    @Published public var displayname: String

    public var avatar: String?
    
    public var cover: String?
    
    public var location: String?
    
    @Published public var about: String
    
    public init() {
        id = kUndefine
        username = UUID().uuidString
        displayname = fakeNames.randomElement()!
        avatar = fakeAvatars.randomElement()!
        about = ""
    }
    
    // init sender for notify list
    public init(id: String, photo: String?, name: String) {
        self.id = id
        username = kUndefine
        self.displayname = name
        self.avatar = photo
        about = ""
    }
    
    public init(id: String, username: String? = nil, displayname: String, avatar: String? = nil, cover: String? = nil, location: String? = nil, about: String? = nil) {
        self.id = id
        self.username = username
        self.displayname = displayname
        self.avatar = avatar
        self.cover = cover
        self.location = location
        self.about = about ?? ""
    }
    
    public init(isDummy: Bool) {
        id = kUndefine
        username = kUndefine
        displayname = kUndefine
        avatar = fakeAvatars.randomElement()!
        about = ""
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
