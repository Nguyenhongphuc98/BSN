//
//  MessageRequest.swift
//  Business
//
//  Created by Phucnh on 11/13/20.
//
import Combine

class MessageRequest: ResourceRequest<EMessage> {
    
    func saveMessage(message: EMessage, publisher: PassthroughSubject<EMessage, Never>) {
        self.resetPath()
        
        self.save(message) { result in
            switch result {
            case .failure:
                let info = "There was an error saving message"
                print(info)
                let mess = EMessage()
                publisher.send(mess)
                
            case .success(let mess):
                publisher.send(mess)
            }
        }
    }
}
