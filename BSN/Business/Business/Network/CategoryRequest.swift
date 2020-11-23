//
//  CategoryRequest.swift
//  Business
//
//  Created by Phucnh on 11/23/20.
//

import Combine

class CategoryRequest: ResourceRequest<ECategory> {
    
    func getCategories(publisher: PassthroughSubject<[ECategory], Never>) {
        self.resetPath()
        
        self.get { result in
            
            switch result {
            case .failure(let reason):
                print(reason)
                let c = ECategory(id: "", name: reason)
                publisher.send([c])
                
            case .success(let categories):
                publisher.send(categories)
            }
        }
    }
}
