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
    
    // Publisher for fetch notes by ubid
    public let getAccountPublisher: PassthroughSubject<EAccount, Never>
    
    public init() {
        // Init resource URL
        networkRequest = AccountRequest(componentPath: "accounts/")
        
        changePublisher = PassthroughSubject<EAccount, Never>()
        getAccountPublisher = PassthroughSubject<EAccount, Never>()
    }
    
    public func login(account: EAccount) {
        networkRequest.login(account: account, publisher: getAccountPublisher)
    }
}
