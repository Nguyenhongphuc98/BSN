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
}
