//
//  BookRequest.swift
//  Business
//
//  Created by Phucnh on 10/20/20.
//

import Combine

extension ResourceRequest where ResourceType == SearchBook {
    
    func searchBook(term:String, publisher: PassthroughSubject<[SearchBook], Never>) {
        self.setPath(resourcePath: "search", params: ["term":term])
        
        self.get { result in
            
            switch result {
            case .failure:
                let message = "There was an error searching the books"
                print(message)
            case .success(let books):
                publisher.send(books)
            }
        }
    }
}

extension ResourceRequest where ResourceType == Book {
    
    func fetchBook(bookID: String, publisher: PassthroughSubject<Book, Never>) {
        self.setPath(resourcePath: bookID)
        
        self.get(isAll: false) { result in
            
            switch result {
            case .failure:
                let message = "There was an error get the book: \(bookID)"
                print(message)
            case .success(let books):
                publisher.send(books[0])
            }
        }
    }
}
