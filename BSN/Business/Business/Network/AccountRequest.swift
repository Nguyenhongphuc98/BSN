//
//  AccountRequest.swift
//  Business
//
//  Created by Phucnh on 11/11/20.
//
import Combine

public var globalAuthorization = ""
class AccountRequest: ResourceRequest<EAccount> {
    
    func setupAuthencation(account: EAccount) {
        let encodeStr = "\(account.username):\(account.password!)".data(using: .utf8)?.base64EncodedString()
        globalAuthorization = "Basic " + encodeStr!
    }
    
    func login(account: EAccount, publisher: PassthroughSubject<EAccount, Never>) {
        self.setPath(resourcePath: "login")
        setupAuthencation(account: account)
        
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
    
    func loginWithFacebook(account: EAccount, publisher: PassthroughSubject<EAccount, Never>) {
        self.setPath(resourcePath: "loginFacebook")
        setupAuthencation(account: account)
        
        self.save(account) { (result) in
            switch result {
            case .failure:
                let message = "There was an error login with facebook"
                print(message)
                publisher.send(EAccount()) // undefine account
                
            case .success(let a):
                publisher.send(a)
            }
        }
    }
    
    func logout() {
        self.setPath(resourcePath: "logout")        
        self.delete()
    }
    
    func signup(account: EAccount, publisher: PassthroughSubject<EAccount, Never>) {
        self.setPath(resourcePath: "register")
        
        self.save(account) { (result) in
            switch result {
            case .failure:
                let message = "There was an error register account"
                print(message)
                publisher.send(EAccount()) // undefine account
                
            case .success(let a):
                publisher.send(a) 
            }
        }
    }
    
    func updateAccount(account: EAccount, publisher: PassthroughSubject<EAccount, Never>) {
        self.resetPath()
        
        self.update(account) { result in
            switch result {
            case .failure:
                let message = "There was an error update account"
                print(message)
                publisher.send(EAccount())
                
            case .success(let a):
                print("update account success!")
                publisher.send(a)
            }
        }
    }
}
