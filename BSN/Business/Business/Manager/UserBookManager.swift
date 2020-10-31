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
    
    // Publisher for save new user book action
    public let savePublisher: PassthroughSubject<EUserBook, Never>
    
    // Publisher for fetch user book by uid
    public let getUserBooksPublisher: PassthroughSubject<[EUserBook], Never>
    
    // Publisher for fetch special user book have `id`
    public let getUserBookPublisher: PassthroughSubject<EUserBook, Never>
    
    public init() {
        // Init resource URL
        networkRequest = UserBookRequest(componentPath: "userBooks/")
        
        savePublisher = PassthroughSubject<EUserBook, Never>()
        getUserBooksPublisher = PassthroughSubject<[EUserBook], Never>()
        getUserBookPublisher = PassthroughSubject<EUserBook, Never>()
    }
    
    public func saveUserBook(ub: EUserBook) {
        networkRequest.saveUserBook(ub: ub, publisher: savePublisher)
    }
    
    public func getUserBooks(uid: String) {
        networkRequest.fetchUserBooks(uid: uid, publisher: getUserBooksPublisher)
    }
    
    public func getUserBook(ubid: String) {
        networkRequest.fetchUserBooks(ubid: ubid, publisher: getUserBookPublisher)
    }
}
