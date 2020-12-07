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
    public let updatePublisher: PassthroughSubject<Int, Never> // status code
    
    public init() {
        // Init resource URL
        networkRequest = UserCategoryRequest(componentPath: "userCategories/")
        
        categoriesPublisher = PassthroughSubject<[EUserCategory], Never>()
        updatePublisher = PassthroughSubject<Int, Never>()
    }
    
    public func getCategoriesBy(uid: String) {
        networkRequest.getCategories(uid: uid, publisher: categoriesPublisher)
    }
    
    public func updateUsercategories(userCategories: [EUserCategory]) {
        networkRequest.updateCategories(userCategories: userCategories, publisher: updatePublisher)
    }
}
