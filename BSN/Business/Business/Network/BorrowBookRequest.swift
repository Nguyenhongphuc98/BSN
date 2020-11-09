//
//  BorrowBookRequest.swift
//  Business
//
//  Created by Phucnh on 11/9/20.
//

import Combine

class BorrowBookRequest: ResourceRequest<EBorrowBook> {
    
    func saveBorrowBook(borrowBook: EBorrowBook, publisher: PassthroughSubject<EBorrowBook, Never>) {
        self.resetPath()
        
        self.save(borrowBook) { result in
            self.processChangeBorrowBookResult(result: result, method: "save", publisher: publisher)
        }
    }
    
//    func deleteReview(reviewID: String) {
//        self.setPath(resourcePath: reviewID)
//        self.delete()
//    }
    
    func processChangeBorrowBookResult(result: SaveResult<EBorrowBook>, method: String, publisher: PassthroughSubject<EBorrowBook, Never>) {
        
        switch result {
        case .failure:
            let message = "There was an error \(method) borrow book"
            print(message)
            let bb = EBorrowBook()
            publisher.send(bb)
            
        case .success(let bb):
            publisher.send(bb)
        }
    }
}
