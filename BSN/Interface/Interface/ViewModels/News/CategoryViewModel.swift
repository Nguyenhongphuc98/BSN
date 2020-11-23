//
//  BookCategoryViewModel.swift
//  Interface
//
//  Created by Phucnh on 9/29/20.
//

import SwiftUI
import Business

class CategoryViewModel: NetworkViewModel {
    
    @Published var categories: [Category]
    
    private var categoryManager: CategoryManager
    
    override init() {
        categories = []
        categoryManager = CategoryManager()
        
        super.init()
        observerData()
        fetchData()
    }
    
    func fetchData() {
        isLoading = true
        categoryManager.getCategories()
    }
    
    private func observerData() {
        categoryManager
            .getCategoriesPublisher
            .sink {[weak self] (categories) in
                
                guard let self = self else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.isLoading = false
                    
                    self.categories = categories.map({ c in
                        Category(id: c.id, name: c.name)
                    })
                }
            }
            .store(in: &cancellables)
    }
}
