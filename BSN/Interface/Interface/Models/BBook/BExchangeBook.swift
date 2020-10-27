//
//  BExchangeBook.swift
//  Interface
//
//  Created by Phucnh on 10/27/20.
//

import SwiftUI

class BExchangeBook: ObservableObject, Identifiable {
    
    var id: String?
    
    // The book who create exchange need change to other book
    var needChangeBook: BUserBook
    
    // The book who create exchange want to obtain
    var wantChangeBook: BUserBook?
    
    // When it just create, no book want to change available
    var wantChangeBID: String
    
    var distance: Float
    
    init() {
        id = UUID().uuidString
        needChangeBook = BUserBook()
        wantChangeBook = BUserBook()
        wantChangeBID = UUID().uuidString
        distance = 456
    }
}
