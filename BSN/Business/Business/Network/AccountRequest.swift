//
//  AccountRequest.swift
//  Business
//
//  Created by Phucnh on 11/11/20.
//
import Combine

class AccountRequest: ResourceRequest<EAccount> {
    
    static var authorization: String = ""
    
    func login(account: EAccount, publisher: PassthroughSubject<EAccount, Never>) {
        self.setPath(resourcePath: "login")
        let encodeStr = "\(account.username):\(account.password)".data(using: .utf8)?.base64EncodedString()
        AccountRequest.authorization = "Basic " + encodeStr!
        
        self.get(isAll: false) { result in
            
            switch result {
            case .failure(let reason):
                print(reason)
                var a = EAccount()
                a.username = reason
                publisher.send(a)
                
            case .success(let accounts):
                publisher.send(accounts[0])
            }
        }
    }
}
