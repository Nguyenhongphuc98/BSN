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
}
