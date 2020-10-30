//
//  UserBookRequest.swift
//  Business
//
//  Created by Phucnh on 10/29/20.
//

import Combine

class UserBookRequest: ResourceRequest<UserBook> {
    
    func fetchUserBooks(uid: String, publisher: PassthroughSubject<[UserBook], Never>) {
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
    
    func fetchUserBooks(ubid: String, publisher: PassthroughSubject<UserBook, Never>) {
        self.setPath(resourcePath: "search", params: ["ubid":ubid])
        
        self.get { result in
            
            switch result {
            case .failure:
                let message = "There was an error searching the user-books"
                print(message)
                let ub = UserBook()
                publisher.send(ub)
                
            case .success(let books):
                publisher.send(books[0])
            }
        }
    }
    
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
