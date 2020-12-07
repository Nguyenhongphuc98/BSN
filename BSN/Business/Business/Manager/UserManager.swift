//
//  UserManager.swift
//  Business
//
//  Created by Phucnh on 11/11/20.
//

import Combine

public class UserManager {
    
    private let networkRequest: UserRequest
    
    // Publisher for save new user and update user action
    public let changePublisher: PassthroughSubject<EUser, Never>
    
    // Publisher for fetch user by uid
    public let getUserPublisher: PassthroughSubject<EUser, Never>
    
    public init() {
        // Init resource URL
        networkRequest = UserRequest(componentPath: "users/")
        
        changePublisher = PassthroughSubject<EUser, Never>()
        getUserPublisher = PassthroughSubject<EUser, Never>()
    }
    
    public func getUser(aid: String) {
        networkRequest.getUser(aid: aid, publisher: getUserPublisher)
    }
    
    public func getUser(uid: String) {
        networkRequest.getUser(uid: uid, publisher: getUserPublisher)
    }
    
    public func updateUser(user: EUser) {
        networkRequest.updateUser(user: user, publisher: changePublisher)
    }
}
