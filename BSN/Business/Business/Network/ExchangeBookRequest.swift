//
//  ExchangeBookRequest.swift
//  Business
//
//  Created by Phucnh on 10/30/20.
//

import Combine

class ExchangeBookRequest: ResourceRequest<EExchangeBook> {
    
    func fetchNewsestExchangeBooks(page: Int, per: Int, publisher: PassthroughSubject<[EExchangeBook], Never>) {
        self.setPath(resourcePath: "newest", params: ["page":String(page), "per":String(per)])

        self.get { result in

            switch result {
            case .failure:
                let message = "There was an error fetch newest exchange book - page: \(page)"
                print(message)
            case .success(let ebs):
                publisher.send(ebs)
            }
        }
    }
    
    // Fetch all available exchange book have user book 1 (need change) bid
    func fetchAvailableExchangeBooks(bid: String, publisher: PassthroughSubject<[EExchangeBook], Never>) {
        self.setPath(resourcePath: "availables/\(bid)")

        self.get { result in

            switch result {
            case .failure:
                let message = "There was an error fetch availables exchange book"
                print(message)
            case .success(let ebs):
                publisher.send(ebs)
            }
        }
    }
    
    func fetchComputeExchangeBook(ebid: String, publisher: PassthroughSubject<EExchangeBook, Never>) {
        self.setPath(resourcePath: "compute/\(ebid)")

        self.get(isAll: false) { result in

            switch result {
            case .failure:
                let message = "There was an error fetch compute exchange book - id: \(ebid)"
                print(message)
                publisher.send(EExchangeBook())
            case .success(let ebs):
                publisher.send(ebs[0])
            }
        }
    }
    
    func fetchDetailExchangeBook(ebid: String, publisher: PassthroughSubject<EExchangeBook, Never>) {
        self.setPath(resourcePath: "detail/\(ebid)")

        self.get(isAll: false) { result in

            switch result {
            case .failure:
                let message = "There was an error fetch detail exchange book - id: \(ebid)"
                print(message)
                publisher.send(EExchangeBook())
            case .success(let ebs):
                publisher.send(ebs[0])
            }
        }
    }
    
    func fetchHistoryExchangeBook(publisher: PassthroughSubject<[EExchangeBook], Never>) {
        self.setPath(resourcePath: "history")
        
        self.get { result in
            
            switch result {
            case .failure(let reason):
                print(reason)
                let eb = EExchangeBook()
                eb.firstOwnerName = reason
                publisher.send([eb])
                
            case .success(let ebs):
                publisher.send(ebs)
            }
        }
    }
    
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
    
    func updateExchangeBook(eb: EExchangeBook, publisher: PassthroughSubject<EExchangeBook, Never>) {
        self.setPath(resourcePath: "\(eb.id!)")
        
        self.update(eb) { result in
            
            switch result {
            case .failure:
                let message = "There was an error when update exchange book"
                print(message)
                /// Publish a undefine exchange book
                let ub = EExchangeBook()
                publisher.send(ub)
                
            case .success(let eb):
                publisher.send(eb)
            }
        }
    }
    
    func cancelExchangeReq(ebID: String) {
        self.setPath(resourcePath: "cancel/\(ebID)")
        
        self.get(isAll: false) { result in
            
            switch result {
            case .failure(let reason):
                print(reason)
                
            case .success(let ebs):
                print("update success \(String(describing: ebs[0].id)) - \(String(describing: ebs[0].state))")
            }
        }
    }
}
