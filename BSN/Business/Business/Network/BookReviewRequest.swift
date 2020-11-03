//
//  BookReviewRequest.swift
//  Business
//
//  Created by Phucnh on 11/3/20.
//

import Combine

class BookReviewRequest: ResourceRequest<EBookReview> {
    
    func fetchBookReviews(bid: String, publisher: PassthroughSubject<[EBookReview], Never>) {
        self.setPath(resourcePath: "search", params: ["bid":bid])
        
        self.get { result in
            
            switch result {
            case .failure:
                let message = "There was an error searching review of book: \(bid)"
                print(message)
                publisher.send([EBookReview()])
                
            case .success(let reviews):
                publisher.send(reviews)
            }
        }
    }
}
