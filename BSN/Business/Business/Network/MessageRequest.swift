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
    
    func fetchMessages(page: Int, per: Int, chatID: String, publisher: PassthroughSubject<[EMessage], Never>) {
        self.setPath(resourcePath: "newest", params: ["page":String(page), "per":String(per), "chatid":String(chatID)])
        
        self.get { result in
            
            switch result {
            case .failure(let reason):
                print(reason)
                let mess = EMessage()
                publisher.send([mess])
                
            case .success(let messages):
                publisher.send(messages)
            }
        }
    }
}
