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
    
    func searchChats(partnerName: String, publisher: PassthroughSubject<[EChat], Never>) {
        self.setPath(resourcePath: "user", params: ["name":partnerName])
        
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
    
    func getChat(uid1: String, uid2: String, publisher: PassthroughSubject<EChat, Never>) {
        self.setPath(resourcePath: "search", params: ["uid1":uid1, "uid2": uid2])
        
        self.get(isAll: false) { result in
            
            switch result {
            case .failure(let reason):
                print(reason)
                var c = EChat()
                c.firstUserName = reason
                publisher.send(c)
                
            case .success(let chats):
                publisher.send(chats[0])
            }
        }
    }
    
    func updateChat(chat: EChat) {
        self.setPath(resourcePath: chat.id!)
        
        self.update(chat) { result in
            switch result {
            case .failure:
                print("There was an error when update chat")
                
            case .success:
                print("Updated chat: \(chat.id!)")
            }
        }
    }
}
