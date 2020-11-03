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
        distance = 0
        self.distance = caculateDistance(rawLocation: partnerLocation)
    }
    
    // init for prepare submit with available transaction
    init(id: String, firstTitle: String, firstAuthor: String, firstCover: String?, firstOwner: String, firstStatusDes: String, firstStatus: String, secondStatusDes: String?, secondStatus: String?, secondTitle: String, secondAuthor: String, secondCover: String?) {

        self.id = id
        needChangeBook = BUserBook(
            ownerName: firstOwner,
            status: firstStatus,
            title: firstTitle,
            author: firstAuthor,
            cover: firstCover,
            des: firstStatusDes
        )
        wantChangeBook = BUserBook(
            status: secondStatus,
            title: secondTitle,
            author: secondAuthor,
            cover: secondCover,
            des: secondStatusDes
        )
        
        self.distance = 0
    }
    
    // Raw location "la-lo-name..."
    func caculateDistance(rawLocation: String) -> Float {
        let los = rawLocation.split(separator: "-")
        let la1 = Float(los[0])!
        let lo1 = Float(los[1])!
        
        return getDistanceFromLatLonInKm(lat1: la1, lon1: lo1)
    }
}

extension BExchangeBook: Hashable {
    
    static func == (lhs: BExchangeBook, rhs: BExchangeBook) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        return hasher.combine(self.id)
    }
}
