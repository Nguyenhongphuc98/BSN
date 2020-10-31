//
//  BookRequest.swift
//  Business
//
//  Created by Phucnh on 10/20/20.
//

import Combine

// MARK: - Search book
class SearchBookRequest: ResourceRequest<ESearchBook> {
    
    func searchBook(term:String, publisher: PassthroughSubject<[ESearchBook], Never>) {
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
    
    func searchBook(isbn:String, publisher: PassthroughSubject<ESearchBook, Never>) {
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

// MARK: - Search book
class BookRequest: ResourceRequest<EBook> {
    
    func fetchBook(bookID: String, publisher: PassthroughSubject<EBook, Never>) {
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
    
    func saveBook(book: EBook, publisher: PassthroughSubject<EBook, Never>) {
        self.resetPath()
        
        self.save(book) { result in
            
            switch result {
            case .failure:
                let message = "There was an error save book"
                print(message)
                var b = EBook()
                b.id = "undefine"
                publisher.send(b)
            case .success(let book):
                publisher.send(book)
            }
        }
    }
}
