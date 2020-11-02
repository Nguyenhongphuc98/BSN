//
//  ExchangeBookRequest.swift
//  Business
//
//  Created by Phucnh on 10/30/20.
//

import Combine

class ExchangeBookRequest: ResourceRequest<EExchangeBook> {
    
    func fetchExchangeBooks(page: Int, per: Int, publisher: PassthroughSubject<[EExchangeBook], Never>) {
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
