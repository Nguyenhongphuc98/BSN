//
//  UserRequest.swift
//  Business
//
//  Created by Phucnh on 11/11/20.
//
import Combine

class UserRequest: ResourceRequest<EUser> {
    
    func getUser(aid: String, publisher: PassthroughSubject<EUser, Never>) {
        self.setPath(resourcePath: "search", params: ["aid":aid])
        
        self.get(isAll: false) { result in
            
            switch result {
            case .failure(let reason):
                print(reason)
                var u = EUser()
                u.displayname = reason
                publisher.send(u)
                
            case .success(let users):
                publisher.send(users[0])
            }
        }
    }
    
    func getUser(uid: String, publisher: PassthroughSubject<EUser, Never>) {
        self.setPath(resourcePath: "\(uid)")
        
        self.get(isAll: false) { result in
            
            switch result {
            case .failure(let reason):
                print(reason)
                var u = EUser()
                u.displayname = reason
                publisher.send(u)
                
            case .success(let users):
                publisher.send(users[0])
            }
        }
    }
    
    func updateUser(user: EUser, publisher: PassthroughSubject<EUser, Never>) {
        self.setPath(resourcePath: user.id!)
        
        self.update(user) { result in
            switch result {
            case .failure:
                let message = "There was an error update user"
                print(message)
                publisher.send(EUser())
                
            case .success(let u):
                print("update user success!")
                publisher.send(u)
            }
        }
    }
}
