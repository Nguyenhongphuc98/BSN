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
    
    func saveBookReview(bookReview: EBookReview, publisher: PassthroughSubject<EBookReview, Never>) {
        self.resetPath()
        
        self.save(bookReview) { result in
            self.processChangeBookReviewResult(result: result, method: "save", publisher: publisher)
        }
    }
    
    func deleteReview(reviewID: String) {
        self.setPath(resourcePath: reviewID)
        self.delete()
    }
    
    func processChangeBookReviewResult(result: SaveResult<EBookReview>, method: String, publisher: PassthroughSubject<EBookReview, Never>) {
        
        switch result {
        case .failure:
            let message = "There was an error \(method) book review"
            print(message)
            let br = EBookReview()
            publisher.send(br)
            
        case .success(let br):
            publisher.send(br)
        }
    }
}
