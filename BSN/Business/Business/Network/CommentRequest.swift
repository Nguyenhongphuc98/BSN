//
//  CommentRequest.swift
//  Business
//
//  Created by Phucnh on 11/24/20.
//
import Combine

class CommentRequest: ResourceRequest<EComment> {
 
    func saveComment(comment: EComment, publisher: PassthroughSubject<EComment, Never>) {
        self.resetPath()
        
        self.save(comment) { result in
            switch result {
            case .failure:
                let message = "There was an error when saving comment"
                print(message)
                let c = EComment()
                publisher.send(c)
                
            case .success(let c):
                publisher.send(c)
            }
        }
    }
    
    // page start from 0 (manual implement start from 0)
    func fetchNewsestComments(pid: String, page: Int, per: Int, publisher: PassthroughSubject<[EComment], Never>) {
        self.setPath(resourcePath: "newest", params: ["page":String(page), "per":String(per), "pid":String(pid)])

        self.get { result in

            switch result {
            case .failure(let message):
                print("At fetch newest comments \(message)")
            case .success(let comments):
                publisher.send(comments)
            }
        }
    }
    
    func fetchSubComments(parentId: String, publisher: PassthroughSubject<[EComment], Never>) {
        self.setPath(resourcePath: "subs", params: ["parentId":String(parentId)])

        self.get { result in

            switch result {
            case .failure(let message):
                print("At fetch sub comments \(message)")
            case .success(let comments):
                publisher.send(comments)
            }
        }
    }
    
    func deleteComment(commentID: String) {
        self.setPath(resourcePath: commentID)
        self.delete()
    }
}
