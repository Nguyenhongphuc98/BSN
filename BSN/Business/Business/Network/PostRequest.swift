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
    
    func fetchPost(pid: String, publisher: PassthroughSubject<EPost, Never>) {
        self.setPath(resourcePath: "detail/\(pid)")

        self.get(isAll: false) { result in

            switch result {
            case .failure(let message):
                print("At fetch post \(message)")
                let post = EPost()
                publisher.send(post)
                
            case .success(let posts):
                publisher.send(posts[0])
            }
        }
    }
    
    // page start from 0 (manual implement start from 0)
    func fetchNewsestPosts(page: Int, per: Int, publisher: PassthroughSubject<[EPost], Never>) {
        self.setPath(resourcePath: "newest", params: ["page":String(page), "per":String(per)])

        self.get { result in

            switch result {
            case .failure(let message):
                print("At fetch newest posts \(message)")
            case .success(let posts):
                publisher.send(posts)
            }
        }
    }
    
    // page start from 0 (manual implement start from 0)
    func fetchPersonalNewsestPosts(page: Int, per: Int, uid: String, publisher: PassthroughSubject<[EPost], Never>) {
        self.setPath(resourcePath: "personalNewest", params: ["page":String(page), "per":String(per), "uid":uid])

        self.get { result in

            switch result {
            case .failure(let message):
                print("At fetch personal newest posts \(message)")
            case .success(let posts):
                publisher.send(posts)
            }
        }
    }
    
    func deletePost(postID: String) {
        self.setPath(resourcePath: postID)
        self.delete()
    }
}
