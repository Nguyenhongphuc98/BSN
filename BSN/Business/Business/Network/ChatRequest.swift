//
//  ChatRequest.swift
//  Business
//
//  Created by Phucnh on 11/14/20.
//
import Combine

class ChatRequest: ResourceRequest<EChat> {
    
    func getNewestChats(page: Int, per: Int, publisher: PassthroughSubject<[EChat], Never>) {
        self.setPath(resourcePath: "newest", params: ["page":String(page), "per": String(per)])
        
        self.get { result in
            
            switch result {
            case .failure(let reason):
                print(reason)
                var c = EChat()
                c.firstUserName = reason
                publisher.send([c])
                
            case .success(let chats):
                publisher.send(chats)
            }
        }
    }
}
