//
//  Account.swift
//
//
//  Created by Phucnh on 10/15/20.
//

import Fluent
import Vapor

final class Account: Model {
    
    static let schema = "account"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "username")
    var username: String
    
    @Field(key: "password")
    var password: String
    
    @Field(key: "is_onboarded")
    var isOnboarded: Bool
    
    init() { }
    
    init(id: UUID? = nil, username: String, password: String, isOnboard: Bool = false) {
        self.id = id
        self.username = username
        self.password = password
        self.isOnboarded = isOnboard
    }
}

extension Account: Content { }

extension Account {
    
    func asPublic() -> Account {
        return Account(
            id: self.id,
            username: self.username,
            password: "",
            isOnboard: self.isOnboarded
        )
    }
}

extension Account {
    struct Create: Content {
        var name: String
        var username: String // in this case, we using email
        var password: String
        var confirmPassword: String
    }
    
    struct Update: Content {
        var username: String
        var password: String?
        var isOnboarded: Bool?
    }
}

extension Account.Create: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("name", as: String.self, is: !.empty)
        validations.add("username", as: String.self, is: .email)
        validations.add("password", as: String.self, is: .count(8...))
    }
}

extension Account: ModelAuthenticatable {
    static let usernameKey = \Account.$username
    static let passwordHashKey = \Account.$password

    func verify(password: String) throws -> Bool {
        try Bcrypt.verify(password, created: self.password)
    }
}
