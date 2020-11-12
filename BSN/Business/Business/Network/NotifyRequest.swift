//
//  NotifyRequest.swift
//  Business
//
//  Created by Phucnh on 11/12/20.
//
import Combine

class NotifyRequest: ResourceRequest<ENotify> {
    
    func getNotifies(page: Int, per: Int, publisher: PassthroughSubject<[ENotify], Never>) {
        self.setPath(resourcePath: "", params: ["page":String(page), "per":String(per)])
        
        self.get { result in
            
            switch result {
            case .failure(let reason):
                print(reason)
                var n = ENotify()
                n.actorName = reason
                publisher.send([n])
                
            case .success(let notifies):
                publisher.send(notifies)
            }
        }
    }
}
