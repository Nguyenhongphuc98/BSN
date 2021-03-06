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
    
    public let getGuestFollowingPublisher: PassthroughSubject<EUserfollow, Never>
    
    public init() {
        // Init resource URL
        networkRequest = UserFollowRequest(componentPath: "userFollows/")
        
        getFollowingsPublisher = PassthroughSubject<[EUserfollow], Never>()
        getFollowingPublisher = PassthroughSubject<EUserfollow, Never>()
        getGuestFollowingPublisher = PassthroughSubject<EUserfollow, Never>()
    }
    
    public func getFollowing(followerID: String, name: String) {
        networkRequest.searchFollowing(followerID: followerID, term: name, publisher: getFollowingsPublisher)
    }
    
    public func getUserFollow(followerId: String, userID: String) {
        networkRequest.getUserFollow(followerId: followerId, tartgetId: userID, publisher: getFollowingPublisher)
    }
    
    public func getGuestFollow(followerId: String, userID: String) {
        networkRequest.getGuestFollow(guestID: followerId, userID: userID, publisher: getGuestFollowingPublisher)
    }
    
    public func makeFollow(follow: EUserfollow) {
        networkRequest.saveUserFollow(uf: follow, publisher: getFollowingPublisher)
    }
    
    public func unfollow(followerId: String, targetId: String) {
        networkRequest.deleteUserFollow(followerId: followerId, targetId: targetId)
    }
    
    public func acceptFollowRequest(followID: String) {
        networkRequest.acceptUserFollow(followID: followID)
    }
}
