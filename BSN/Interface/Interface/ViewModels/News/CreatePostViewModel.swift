//
//  CreatePostViewModel.swift
//  Interface
//
//  Created by Phucnh on 9/29/20.
//

import SwiftUI
import Business

class CreatePostViewModel: NetworkViewModel {
    
    @Published var photo: Data
    
    @Published var category: Category
    
    private var postManager: PostManager
    
    var didSaveSuccess: (() -> Void)?
    
    override init() {
        photo = Data()
        category = Category(id: kUndefine, name: "Chọn chủ đề")
        postManager = PostManager()
        print("did init Create Post ViewModel")
        
        super.init()
        observerSavePost()
    }
    
    func post(content: String, quote: String) {
        guard !content.isEmpty else {
            resourceInfo = .invalid_empty
            showAlert = true
            return
        }
        
        guard category.id != kUndefine else {
            resourceInfo = .invalid_category
            showAlert = true
            return
        }
        
        isLoading = true
        let p = EPost(
            categoryID: category.id,
            authorID: AppManager.shared.currenUID,
            quote: quote.isEmpty ? nil : quote,
            content: content
        )
        postManager.savePost(post: p)
    }
}

// MARK: - Observer
extension CreatePostViewModel {
    private func observerSavePost() {
        postManager
            .postPublisher
            .sink {[weak self] (p) in
                
                guard let self = self else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.isLoading = false
                    if p.id == kUndefine {
                        self.resourceInfo =  .savefailure
                        self.showAlert = true
                    } else {
                        self.didSaveSuccess?()
                    }
                }
            }
            .store(in: &cancellables)
    }
}
