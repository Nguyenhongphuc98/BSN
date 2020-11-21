//
//  BAvailableTransaction.swift
//  Interface
//
//  Created by Phucnh on 10/28/20.
//

import SwiftUI
import Business

class BAvailableTransaction: ObservableObject, AppendUniqueAble, Equatable {
    
    var id: String?
    
    var createrID: String
    
    var createrPhoto: String
    
    var createrName: String
    
    // book to borrow or book want to change ID
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
    
    init(eb: EExchangeBook) {
        self.id = eb.id
        self.createrPhoto = eb.firstAvatar!
        self.createrName = eb.firstOwnerName!
        self.createrID = eb.firstUserID!
        self.status = BookStatus(rawValue: eb.firstStatus!)!
        self.distance = caculateDistance(rawLocation: eb.location!)
        self.bookID = eb.secondBookID!
    }
}

class BAvailableExchange: BAvailableTransaction {
    
    // id of book want to change
    var exchangeBookID: String
    
    var exchangeBookName: String
    
    override init() {
        exchangeBookID = UUID().uuidString
        exchangeBookName = "Muốn giỏi phải học"
        super.init()
    }
    
    override init(eb: EExchangeBook) {
        exchangeBookID = eb.exchangeBookID!
        exchangeBookName = eb.secondTitle!
        
        super.init(eb: eb)
    }
}
