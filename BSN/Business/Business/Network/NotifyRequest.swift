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
    
    // Actualy, it just can update seen field to true or false
    func updateNotify(notify: ENotify, publisher: PassthroughSubject<ENotify, Never>) {
        self.setPath(resourcePath: notify.id)
        
        self.update(notify) { result in
            switch result {
            case .failure:
                let message = "There was an error when update notify"
                print(message)
                // We don't care result, it's not too importance
                
            case .success(let n):
                publisher.send(n)
            }
        }
    }
}
