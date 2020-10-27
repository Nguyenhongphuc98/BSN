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
        
        self.getAll { result in
            
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
    
    
}
