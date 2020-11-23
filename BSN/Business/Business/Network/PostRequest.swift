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
    
    // page start from 0 (manual implement start from 0)
    func fetchNewsestPosts(page: Int, per: Int, publisher: PassthroughSubject<[EPost], Never>) {
        self.setPath(resourcePath: "newest", params: ["page":String(page), "per":String(per)])

        self.get { result in

            switch result {
            case .failure:
                let message = "There was an error fetch newest posts - page: \(page)"
                print(message)
            case .success(let posts):
                publisher.send(posts)
            }
        }
    }
}
