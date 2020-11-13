//
//  UserFollowManager.swift
//  Business
//
//  Created by Phucnh on 11/13/20.
//

import Combine

public class UserFollowManager {
    
    private let networkRequest: UserFollowRequest
    
    // Publisher for fetch notifies of current user in session
    public let getFollowingPublisher: PassthroughSubject<[EUserfollow], Never>
    
    public init() {
        // Init resource URL
        networkRequest = UserFollowRequest(componentPath: "userFollows/")
        
        getFollowingPublisher = PassthroughSubject<[EUserfollow], Never>()
    }
    
    public func getFollowing(followerID: String, name: String) {
        networkRequest.searchFollowing(followerID: followerID, term: name, publisher: getFollowingPublisher)
    }
}
