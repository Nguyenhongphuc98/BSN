//
//  UserBookManager.swift
//  Business
//
//  Created by Phucnh on 10/29/20.
//

import Combine

public class UserBookManager {
    
    public static let shared: UserBookManager = UserBookManager()
    
    private let booksRequest: ResourceRequest<UserBook>
    
    private let networkRequest: UserBookRequest
    
    // Publisher for save new user book action
    public let savePublisher: PassthroughSubject<UserBook, Never>
    
    // Publisher for fetch user book by uid
    public let getUserBooksPublisher: PassthroughSubject<[UserBook], Never>
    
    public init() {
        // Init resource URL
        booksRequest = ResourceRequest<UserBook>(componentPath: "userBooks/")
        networkRequest = UserBookRequest(componentPath: "userBooks/")
        
        savePublisher = PassthroughSubject<UserBook, Never>()
        getUserBooksPublisher = PassthroughSubject<[UserBook], Never>()
    }
    
    public func saveUserBook(ub: UserBook) {
        booksRequest.saveUserBook(ub: ub, publisher: savePublisher)
    }
    
    public func getUserBooks(uid: String) {
        networkRequest.fetchUserBooks(uid: uid, publisher: getUserBooksPublisher)
    }
}
