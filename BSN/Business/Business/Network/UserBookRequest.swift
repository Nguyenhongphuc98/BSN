//
//  UserBookRequest.swift
//  Business
//
//  Created by Phucnh on 10/29/20.
//

import Combine

extension ResourceRequest where ResourceType == UserBook {
    
//    func fetchBook(bookID: String, publisher: PassthroughSubject<UserBook, Never>) {
//        self.setPath(resourcePath: bookID)
//
//        self.get(isAll: false) { result in
//
//            switch result {
//            case .failure:
//                let message = "There was an error get the book: \(bookID)"
//                print(message)
//            case .success(let books):
//                publisher.send(books[0])
//            }
//        }
//    }
    
    func saveUserBook(ub: UserBook, publisher: PassthroughSubject<UserBook, Never>) {
        self.resetPath()
        
        self.save(ub) { result in
            
            switch result {
            case .failure:
                let message = "There was an error save user_book"
                print(message)
                var ub = UserBook()
                ub.id = "undefine"
                publisher.send(ub)
                
            case .success(let ub):
                publisher.send(ub)
            }
        }
    }
}
