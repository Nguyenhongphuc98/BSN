//
//  BookReviewManager.swift
//  Business
//
//  Created by Phucnh on 11/3/20.
//

import Combine

public class BookReviewManager {
    
    private let networkRequest: BookReviewRequest
    
    // Publisher for save new note and update note action
    public let changePublisher: PassthroughSubject<EBookReview, Never>
    
    // Publisher for fetch notes by ubid
    public let getReviewsPublisher: PassthroughSubject<[EBookReview], Never>
    
    public init() {
        // Init resource URL
        networkRequest = BookReviewRequest(componentPath: "bookReviews/")
        
        changePublisher = PassthroughSubject<EBookReview, Never>()
        getReviewsPublisher = PassthroughSubject<[EBookReview], Never>()
    }
    
    public func getReviews(bid: String) {
        networkRequest.fetchBookReviews(bid: bid, publisher: getReviewsPublisher)
    }
    
    public func saveReview(review: EBookReview) {
        networkRequest.saveBookReview(bookReview: review, publisher: changePublisher)
    }

    public func deleteReview(reivewID: String) {
        networkRequest.deleteReview(reviewID: reivewID)
    }
}
