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
            
            self.processGetFollow(result: result, publisher: publisher)
        }
    }
    
    // check gest is following current user
    func getGuestFollow(guestID: String, userID: String, publisher: PassthroughSubject<EUserfollow, Never>) {
        self.setPath(resourcePath: "\(guestID)/\(userID)")
        
        self.get(isAll: false) { result in
            
            self.processGetFollow(result: result, publisher: publisher)
        }
    }
    
    func processGetFollow(result: GetResourcesRequest<EUserfollow>, publisher: PassthroughSubject<EUserfollow, Never>) {
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
    
    func saveUserFollow(uf: EUserfollow, publisher: PassthroughSubject<EUserfollow, Never>) {
        self.resetPath()
        
        self.save(uf) { (result) in
            switch result {
            case .failure:
                let message = "There was an error save user_follow"
                print(message)
                
            case .success(let u):
                publisher.send(u)
                print("save user-follow success with id: - \(String(describing: u.id))")
            }
        }
    }
    
    func deleteUserFollow(followerId: String, targetId: String) {
        self.setPath(resourcePath: "\(followerId)/\(targetId)")
        self.delete()
    }
    
    func acceptUserFollow(followID: String) {
        self.setPath(resourcePath: "accept/\(followID)")
        self.get(isAll: false) { (result) in
            // we don't care result
            // Assum it will ok :)
        }
    }
}
