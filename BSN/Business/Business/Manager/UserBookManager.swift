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
    
    public let savePublisher: PassthroughSubject<UserBook, Never>
    
    public init() {
        // Init resource URL
        booksRequest = ResourceRequest<UserBook>(componentPath: "userBooks/")
        
        savePublisher = PassthroughSubject<UserBook, Never>()
    }
    
    public func saveUserBook(ub: UserBook) {
        booksRequest.saveUserBook(ub: ub, publisher: savePublisher)
    }
}
