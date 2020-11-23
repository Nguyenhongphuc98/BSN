//
//  PostRequest.swift
//  Business
//
//  Created by Phucnh on 11/23/20.
//
import Combine

class PostRequest: ResourceRequest<EPost> {
 
    func savePost(post: EPost, publisher: PassthroughSubject<EPost, Never>) {
        self.resetPath()
        
        self.save(post) { result in
            switch result {
            case .failure:
                let message = "There was an error when saving post"
                print(message)
                let p = EPost()
                publisher.send(p)
                
            case .success(let p):
                publisher.send(p)
            }
        }
    }
}
