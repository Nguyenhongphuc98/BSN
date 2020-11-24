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
}
