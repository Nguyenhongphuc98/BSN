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
}
