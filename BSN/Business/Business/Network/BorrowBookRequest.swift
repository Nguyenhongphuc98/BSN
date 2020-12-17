//
//  BorrowBookRequest.swift
//  Business
//
//  Created by Phucnh on 11/9/20.
//

import Combine

class BorrowBookRequest: ResourceRequest<EBorrowBook> {
    
    func fetchBorowBook(bbid: String, publisher: PassthroughSubject<EBorrowBook, Never>) {
        self.setPath(resourcePath: "detail/\(bbid)")
        
        self.get(isAll: false) { result in
            
            switch result {
            case .failure(let message):
                print(message)
                var bb = EBorrowBook()
                bb.bookTitle = message
                publisher.send(bb)
                
            case .success(let bbs):
                publisher.send(bbs[0])
            }
        }
    }
    
    func fetchHistoryBorowBook(publisher: PassthroughSubject<[EBorrowBook], Never>) {
        self.setPath(resourcePath: "history")
        
        self.get { result in
            
            switch result {
            case .failure(let reason):
                print(reason)
                var n = EBorrowBook()
                n.bookTitle = reason
                publisher.send([n])
                
            case .success(let bbs):
                publisher.send(bbs)
            }
        }
    }
    
    func saveBorrowBook(borrowBook: EBorrowBook, publisher: PassthroughSubject<EBorrowBook, Never>) {
        self.resetPath()
        
        self.save(borrowBook) { result in
            self.processChangeBorrowBookResult(result: result, method: "save", publisher: publisher)
        }
    }
    
    func updateBorrowBook(borrowBook: EBorrowBook, publisher: PassthroughSubject<EBorrowBook, Never>) {
        self.setPath(resourcePath: borrowBook.id!)
        
        self.update(borrowBook) { (result) in
            self.processChangeBorrowBookResult(result: result, method: "update", publisher: publisher)
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
