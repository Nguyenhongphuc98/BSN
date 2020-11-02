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
    var wantChangeBID: String?
    
    var distance: Float
    
    init() {
        id = UUID().uuidString
        needChangeBook = BUserBook()
        wantChangeBook = BUserBook()
        wantChangeBID = UUID().uuidString
        distance = 456
    }
    
    init(id: String? = nil, firstTitle: String, firstAuthor: String, firstCover: String, partnerLocation: String, sencondTitle: String, secondAuthor: String) {
        
        self.id = id
        needChangeBook = BUserBook(title: firstTitle, author: firstAuthor, cover: firstCover)
        wantChangeBook = BUserBook(title: sencondTitle, author: secondAuthor)
        
        let los = partnerLocation.split(separator: "-")
        let la1 = Float(los[0])!
        let lo1 = Float(los[1])!
        
        self.distance = getDistanceFromLatLonInKm(lat1: la1, lon1: lo1)
    }
}
