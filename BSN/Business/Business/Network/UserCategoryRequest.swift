//
//  UserCategoryRequest.swift
//  Business
//
//  Created by Phucnh on 12/6/20.
//

import Combine

class UserCategoryRequest: ResourceRequest<EUserCategory> {
    
    func getCategories(uid: String, publisher: PassthroughSubject<[EUserCategory], Never>) {
        self.setPath(resourcePath: "user/\(uid)")
        
        self.get { result in
            
            switch result {
            case .failure(let message):
                print("At fetch categories of user: \(message)")
            case .success(let categories):
                publisher.send(categories)
            }
        }
    }
    
    func updateCategories(userCategories: [EUserCategory], publisher: PassthroughSubject<Int, Never>) {
        self.setPath(resourcePath: "user")
        
        self.save(userCategories) { result in
            switch result {
            case .failure:
                let message = "There was an error update userCategories"
                print(message)
                publisher.send(401) // 401 Unauthorized
                
            case .success(let status):
                print("update userCategories success")
                publisher.send(status)
            }
        }
    }
}
