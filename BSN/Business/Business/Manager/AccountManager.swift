//
//  AccountManager.swift
//  Business
//
//  Created by Phucnh on 11/11/20.
//
import Combine

public class AccountManager {
    
    private let networkRequest: AccountRequest
    
    // Publisher for save new note and update note action
    public let changePublisher: PassthroughSubject<EAccount, Never>
    
    // Publisher for fetch or save account
    public let accountPublisher: PassthroughSubject<EAccount, Never>
    
    public init() {
        // Init resource URL
        networkRequest = AccountRequest(componentPath: "accounts/")
        
        changePublisher = PassthroughSubject<EAccount, Never>()
        accountPublisher = PassthroughSubject<EAccount, Never>()
    }
    
    public func login(account: EAccount) {
        networkRequest.login(account: account, publisher: accountPublisher)
    }
    
    public func loginWithFacebook(account: EAccount) {
        networkRequest.loginWithFacebook(account: account, publisher: accountPublisher)
    }
    
    public func logout() {
        networkRequest.logout()
    }
    
    public func signup(account: EAccount) {
        networkRequest.signup(account: account, publisher: accountPublisher)
    }
    
    public func updateAccount(account: EAccount) {
        networkRequest.updateAccount(account: account, publisher: accountPublisher)
    }
}
