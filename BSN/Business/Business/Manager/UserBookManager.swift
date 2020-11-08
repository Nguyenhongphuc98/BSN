//
//  UserBookManager.swift
//  Business
//
//  Created by Phucnh on 10/29/20.
//

import Combine

public class UserBookManager {
    
    public static let shared: UserBookManager = UserBookManager()
    
    private let networkRequest: UserBookRequest
    
    // Publisher for save new, update user book action
    public let changePublisher: PassthroughSubject<EUserBook, Never>
    
    // Publisher for fetch user book by uid
    public let getUserBooksPublisher: PassthroughSubject<[EUserBook], Never>
    
    // Publisher for fetch special user book have `id`
    public let getUserBookPublisher: PassthroughSubject<EUserBook, Never>
    
    public init() {
        // Init resource URL
        networkRequest = UserBookRequest(componentPath: "userBooks/")
        
        changePublisher = PassthroughSubject<EUserBook, Never>()
        getUserBooksPublisher = PassthroughSubject<[EUserBook], Never>()
        getUserBookPublisher = PassthroughSubject<EUserBook, Never>()
    }
    
    public func saveUserBook(ub: EUserBook) {
        networkRequest.saveUserBook(ub: ub, publisher: changePublisher)
    }
    
    public func getUserBooks(uid: String) {
        networkRequest.fetchUserBooks(uid: uid, publisher: getUserBooksPublisher)
    }
    
    public func getUserBook(ubid: String) {
        networkRequest.fetchUserBook(ubid: ubid, publisher: getUserBookPublisher)
    }
    
    public func updateUserBook(ub: EUserBook) {
        networkRequest.updateUserBook(ub: ub, publisher: changePublisher)
    }
}
