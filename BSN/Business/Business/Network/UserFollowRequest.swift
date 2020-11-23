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
    func getUserFollow(followerId: String, tartgetId: String, publisher: PassthroughSubject<EUserfollow, Never>) {
        self.setPath(resourcePath: "\(followerId)/\(tartgetId)")
        
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
    
    func saveUserFollow(uf: EUserfollow) {
        self.resetPath()
        
        self.save(uf) { (result) in
            switch result {
            case .failure:
                let message = "There was an error save user_follow"
                print(message)
                
            case .success(let u):
                print("save user-follow success with id: - \(String(describing: u.id))")
            }
        }
    }
    
    func deleteUserFollow(followerId: String, targetId: String) {
        self.setPath(resourcePath: "\(followerId)/\(targetId)")
        self.delete()
    }
}
