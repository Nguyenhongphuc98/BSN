//
//  BAvailableTransaction.swift
//  Interface
//
//  Created by Phucnh on 10/28/20.
//

import SwiftUI

class BAvailableTransaction: ObservableObject, Identifiable {
    
    var id: String?
    
    var createrID: String
    
    var createrPhoto: String
    
    var createrName: String
    
    var bookID: String
    
    var status: BookStatus
    
    var distance: Float
    
    init() {
        id = UUID().uuidString
        createrID = UUID().uuidString
        createrName = "Nguyễn Hồng Phúc"
        createrPhoto = fakeAvatars.randomElement()!
        bookID = UUID().uuidString
        status = .old
        distance = 678
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
