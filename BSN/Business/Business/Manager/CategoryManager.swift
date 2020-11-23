//
//  CategoryManager.swift
//  Business
//
//  Created by Phucnh on 11/23/20.
//

import Combine

public class CategoryManager {
    
    private let networkRequest: CategoryRequest
    
    public let getCategoriesPublisher: PassthroughSubject<[ECategory], Never>
    
    public init() {
        // Init resource URL
        networkRequest = CategoryRequest(componentPath: "categories/")
        
        getCategoriesPublisher = PassthroughSubject<[ECategory], Never>()
    }
    
    public func getCategories() {
        networkRequest.getCategories(publisher: getCategoriesPublisher)
    }
}
