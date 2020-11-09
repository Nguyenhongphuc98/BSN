//
//  BAvailableTransaction.swift
//  Interface
//
//  Created by Phucnh on 10/28/20.
//

import SwiftUI
import Business

class BAvailableTransaction: ObservableObject, Identifiable, Equatable {
    
    var id: String?
    
    var createrID: String
    
    var createrPhoto: String
    
    var createrName: String
    
    var bookID: String
    
    var status: BookStatus
    
    var distance: Float
    
    var userBookID: String?
    
    init() {
        id = UUID().uuidString
        createrID = UUID().uuidString
        createrName = "Nguyễn Hồng Phúc"
        createrPhoto = fakeAvatars.randomElement()!
        bookID = UUID().uuidString
        status = .old
        distance = 678
    }
    
    init(userBook: EUserBook) {
        self.id = userBook.id
        self.createrID = userBook.userID!
        self.createrPhoto = userBook.ownerAvatar!
        self.createrName = userBook.ownerName!
        self.bookID = userBook.bookID!
        self.status = BookStatus(rawValue: userBook.status!)!
        self.distance = caculateDistance(rawLocation: userBook.location!)
        self.userBookID = userBook.id
    }
}

class BAvailableExchange: BAvailableTransaction {
    
    var exchangeBookID: String
    
    var exchangeBookName: String
    
    override init() {
        exchangeBookID = UUID().uuidString
        exchangeBookName = "Muốn giỏi phải học"
        super.init()
    }
}

// MARK: - extension
extension BAvailableTransaction: Hashable {
    
    static func == (lhs: BAvailableTransaction, rhs: BAvailableTransaction) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        return hasher.combine(self.id)
    }
}
