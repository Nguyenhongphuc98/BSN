//
//  CreatePostViewModel.swift
//  Interface
//
//  Created by Phucnh on 9/29/20.
//

import SwiftUI

class CreatePostViewModel: ObservableObject {
    
    @Published var quote: String
    
    @Published var content: String
    
    @Published var photo: String
    
    @Published var isPosting: Bool
    
    @Published var category: String
    
    init() {
        quote = ""
        content = ""
        photo = ""
        isPosting = false
        category = fakeCategory[0]
        print("did init Create Post ViewModel")
    }
    
    func post(completeHandle: @escaping (Bool) -> Void) {
        isPosting = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            completeHandle(true)
            self.isPosting = false
        }
    }
}
