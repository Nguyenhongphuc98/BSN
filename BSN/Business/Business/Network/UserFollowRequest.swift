//
//  UserFollowRequest.swift
//  Business
//
//  Created by Phucnh on 11/13/20.
//
import Combine

class UserFollowRequest: ResourceRequest<EUserfollow> {
    
    func searchFollowing(followerID: String, term: String, publisher: PassthroughSubject<[EUserfollow], Never>) {
        self.setPath(resourcePath: "following", params: ["uid": followerID, "term": term])
        
        self.get { result in
            
            switch result {
            case .failure(let reason):
                print(reason)
                var n = EUserfollow()
                n.userName = reason
                publisher.send([n])
                
            case .success(let followings):
                publisher.send(followings)
            }
        }
    }
    
    // check current user follow guest (profile showing)
    func getUserFollow(currentUid: String, guestUid: String, publisher: PassthroughSubject<EUserfollow, Never>) {
        self.setPath(resourcePath: "\(currentUid)/\(guestUid)")
        
        self.get(isAll: false) { result in
            
            switch result {
            case .failure(let reason):
                print(reason)
                var n = EUserfollow()
                n.userName = reason
                publisher.send(n)
                
            case .success(let followings):
                publisher.send(followings[0])
            }
        }
    }
}
