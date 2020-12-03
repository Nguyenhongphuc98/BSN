//
//  CreatePostViewModel.swift
//  Interface
//
//  Created by Phucnh on 9/29/20.
//

import SwiftUI
import Business

class CreatePostViewModel: NetworkViewModel {
    
    @Published var photoUrl: String
    @Published var category: Category
    
    // Upload image to S3
    @Published var uploadProgess: Float
    @Published var isUploading: Bool
    
    private var postManager: PostManager
    
    var didSaveSuccess: (() -> Void)?
    
    override init() {
        photoUrl = ""
        category = Category(id: kUndefine, name: "Chọn chủ đề")
        uploadProgess = 0
        isUploading = false
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
            content: content,
            photo: photoUrl.isEmpty ? nil : photoUrl
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
                    self.photoUrl = ""
                    if p.id == kUndefine {
                        self.resourceInfo =  .savefailure
                        self.showAlert = true
                    } else {
                        let newsfeed = NewsFeed(
                            id: p.id!,
                            category: self.category,
                            content: p.content,
                            quote: p.quote,
                            photo: p.photo
                        )
                        NewsFeedViewModel.shared.addNewPostToTop(news: newsfeed)
                        ProfileViewModel.shared.addNewPostToTop(news: newsfeed)
                        self.didSaveSuccess?()
                    }
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - AWS Utils
extension CreatePostViewModel {
    func upload(image: UIImage) {
        print("start uploading image ...")
        isUploading = true
        objectWillChange.send()
        AWSManager.shared.uploadImage(image: image, progress: {[weak self] ( uploadProgress) in
            
            guard let strongSelf = self else { return }
            strongSelf.uploadProgess = Float(uploadProgress)
            print("uploading: \(uploadProgress)")
            
        }) {[weak self] (uploadedFileUrl, error) in
            
            guard let strongSelf = self else { return }
            if let finalPath = uploadedFileUrl as? String {
                strongSelf.photoUrl = finalPath
            } else {
                //strongSelf.photoUrl = ""
                strongSelf.resourceInfo = .image_upload_fail
                strongSelf.showAlert = true
                print("\(String(describing: error?.localizedDescription))")
            }
            strongSelf.isUploading = false
            strongSelf.objectWillChange.send()
        }
    }
}
