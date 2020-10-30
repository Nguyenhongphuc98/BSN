//
//  ExchangeBookRequest.swift
//  Business
//
//  Created by Phucnh on 10/30/20.
//

import Combine

class ExchangeBookRequest: ResourceRequest<ExchangeBook> {
    
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
    
    func saveExchangeBook(eb: ExchangeBook, publisher: PassthroughSubject<ExchangeBook, Never>) {
        self.resetPath()
        
        self.save(eb) { result in
            
            switch result {
            case .failure:
                let message = "There was an error save user_book"
                print(message)
                /// Publish a undefine exchange book
                let ub = ExchangeBook()
                publisher.send(ub)
                
            case .success(let eb):
                publisher.send(eb)
            }
        }
    }
}
