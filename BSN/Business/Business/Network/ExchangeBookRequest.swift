//
//  ExchangeBookRequest.swift
//  Business
//
//  Created by Phucnh on 10/30/20.
//

import Combine

class ExchangeBookRequest: ResourceRequest<EExchangeBook> {
    
//    func fetchExchangeBooks(uid: String, publisher: PassthroughSubject<[ExchangeBook], Never>) {
//        self.setPath(resourcePath: "search", params: ["uid":uid])
//
//        self.get { result in
//
//            switch result {
//            case .failure:
//                let message = "There was an error searching the user-books"
//                print(message)
//            case .success(let books):
//                publisher.send(books)
//            }
//        }
//    }
    
    func saveExchangeBook(eb: EExchangeBook, publisher: PassthroughSubject<EExchangeBook, Never>) {
        self.resetPath()
        
        self.save(eb) { result in
            
            switch result {
            case .failure:
                let message = "There was an error save user_book"
                print(message)
                /// Publish a undefine exchange book
                let ub = EExchangeBook()
                publisher.send(ub)
                
            case .success(let eb):
                publisher.send(eb)
            }
        }
    }
}
