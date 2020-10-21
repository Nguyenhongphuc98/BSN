//
//  BookRequest.swift
//  Business
//
//  Created by Phucnh on 10/20/20.
//

import Combine

extension ResourceRequest where ResourceType == SearchBook {
    
    func searchBook(term:String, publisher: PassthroughSubject<[SearchBook], Never>) {
        self.setPath(resourcePath: "search?term=" + term)
        self.getAll { result in
            
            switch result {
            case .failure:
                let message = "There was an error getting the categories"
                print(message)
            case .success(let books):
                publisher.send(books)
            }
        }
    }
}
