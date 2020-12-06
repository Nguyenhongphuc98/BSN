//
//  UserCategoryManager.swift
//  Business
//
//  Created by Phucnh on 12/6/20.
//

import Combine

public class UserCategoryManager {
    
    private let networkRequest: UserCategoryRequest
    
    public let categoriesPublisher: PassthroughSubject<[EUserCategory], Never>
    
    public init() {
        // Init resource URL
        networkRequest = UserCategoryRequest(componentPath: "userCategories/")
        
        categoriesPublisher = PassthroughSubject<[EUserCategory], Never>()
    }
    
    public func getCategoriesBy(uid: String) {
        networkRequest.getCategories(uid: uid, publisher: categoriesPublisher)
    }
}
