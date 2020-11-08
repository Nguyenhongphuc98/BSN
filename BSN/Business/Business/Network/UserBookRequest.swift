//
//  UserBookRequest.swift
//  Business
//
//  Created by Phucnh on 10/29/20.
//

import Combine

class UserBookRequest: ResourceRequest<EUserBook> {
    
    func fetchUserBooks(uid: String, publisher: PassthroughSubject<[EUserBook], Never>) {
        self.setPath(resourcePath: "search", params: ["uid":uid])
        
        self.get { result in
            
            switch result {
            case .failure:
                let message = "There was an error searching the user-books"
                print(message)
            case .success(let books):
                publisher.send(books)
            }
        }
    }
    
    func fetchUserBook(ubid: String, publisher: PassthroughSubject<EUserBook, Never>) {
        self.setPath(resourcePath: "search", params: ["ubid":ubid])
        
        self.get { result in
            
            switch result {
            case .failure:
                let message = "There was an error searching the user-book"
                print(message)
                let ub = EUserBook()
                publisher.send(ub)
                
            case .success(let books):
                publisher.send(books[0])
            }
        }
    }
    
    func saveUserBook(ub: EUserBook, publisher: PassthroughSubject<EUserBook, Never>) {
        self.resetPath()
        
        self.save(ub) { result in
            self.processChangeUBResult(result: result, method: "save", publisher: publisher)
        }
    }
    
    func updateUserBook(ub: EUserBook, publisher: PassthroughSubject<EUserBook, Never>) {
        self.setPath(resourcePath: ub.id!)
        
        self.update(ub) { [self] result in
            self.processChangeUBResult(result: result, method: "update", publisher: publisher)
        }
    }
    
    func processChangeUBResult(result: SaveResult<EUserBook >, method: String, publisher: PassthroughSubject<EUserBook, Never>) {
        
        switch result {
        case .failure:
            let message = "There was an error \(method) user-book"
            print(message)
            let ub = EUserBook()
            publisher.send(ub)
            
        case .success(let ub):
            publisher.send(ub)
        }
    }
}
