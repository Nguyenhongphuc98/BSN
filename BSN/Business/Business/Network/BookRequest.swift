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
    
    func searchBook(isbn:String, publisher: PassthroughSubject<SearchBook, Never>) {
        self.setPath(resourcePath: "isbn", params: ["term":isbn])
        
        self.get(isAll: false) { result in
            
            switch result {
            case .failure:
                let message = "There was an error searching the books"
                print(message)
            case .success(let books):
                publisher.send(books[0])
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
    
    func saveBook(book: Book, publisher: PassthroughSubject<Book, Never>) {
        self.resetPath()
        
        self.save(book) { result in
            
            switch result {
            case .failure:
                let message = "There was an error save book"
                print(message)
                var b = Book()
                b.id = "undefine"
                publisher.send(b)
            case .success(let book):
                publisher.send(book)
            }
        }
    }
}
