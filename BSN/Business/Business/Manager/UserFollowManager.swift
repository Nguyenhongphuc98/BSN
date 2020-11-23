//
//  UserFollowManager.swift
//  Business
//
//  Created by Phucnh on 11/13/20.
//

import Combine

public class UserFollowManager {
    
    private let networkRequest: UserFollowRequest
    
    public let getFollowingsPublisher: PassthroughSubject<[EUserfollow], Never>
    
    public let getFollowingPublisher: PassthroughSubject<EUserfollow, Never>
    
    public init() {
        // Init resource URL
        networkRequest = UserFollowRequest(componentPath: "userFollows/")
        
        getFollowingsPublisher = PassthroughSubject<[EUserfollow], Never>()
        getFollowingPublisher = PassthroughSubject<EUserfollow, Never>()
    }
    
    public func getFollowing(followerID: String, name: String) {
        networkRequest.searchFollowing(followerID: followerID, term: name, publisher: getFollowingsPublisher)
    }
    
    public func getUserFollow(followerId: String, userID: String) {
        networkRequest.getUserFollow(currentUid: followerId, guestUid: userID, publisher: getFollowingPublisher)
    }
}
