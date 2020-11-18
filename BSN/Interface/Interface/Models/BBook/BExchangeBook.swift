//
//  BExchangeBook.swift
//  Interface
//
//  Created by Phucnh on 10/27/20.
//

import SwiftUI

class BExchangeBook: ObservableObject, AppendUniqueAble {
    
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
    
    init(id: String? = nil, firstubid: String? = nil, secondubid: String? = nil, firstTitle: String, firstAuthor: String, firstCover: String, partnerLocation: String, sencondTitle: String, secondAuthor: String) {
        
        self.id = id
        needChangeBook = BUserBook(ubid: firstubid, title: firstTitle, author: firstAuthor, cover: firstCover)
        wantChangeBook = BUserBook(ubid: secondubid, title: sencondTitle, author: secondAuthor)
        distance = 0
        self.distance = caculateDistance(rawLocation: partnerLocation)
    }
    
    // init for prepare submit with available transaction
    init(id: String, firstubid: String? = nil, secondubid: String? = nil, firstTitle: String, firstAuthor: String, firstCover: String?, firstOwner: String, firstStatusDes: String, firstStatus: String, secondStatusDes: String?, secondStatus: String?, secondTitle: String, secondAuthor: String, secondCover: String?) {

        self.id = id
        needChangeBook = BUserBook(
            ubid: firstubid,
            ownerName: firstOwner,
            status: firstStatus,
            title: firstTitle,
            author: firstAuthor,
            cover: firstCover,
            des: firstStatusDes
        )
        wantChangeBook = BUserBook(
            ubid: secondubid,
            status: secondStatus,
            title: secondTitle,
            author: secondAuthor,
            cover: secondCover,
            des: secondStatusDes
        )
        
        self.distance = 0
    }
    
    // init for accept/decline or view result
    init(id: String, firstTitle: String, firstAuthor: String, firstCover: String?, firstOwner: String, firstStatusDes: String, secondOwner: String, secondStatusDes: String, secondTitle: String, secondAuthor: String, secondCover: String?) {

        self.id = id
        needChangeBook = BUserBook(
            ownerName: firstOwner,
            title: firstTitle,
            author: firstOwner,
            cover: firstCover,
            des: firstStatusDes
        )
        wantChangeBook = BUserBook(
            ownerName: secondOwner,
            title: secondTitle,
            author: secondAuthor,
            cover: secondCover,
            des: secondStatusDes
        )
        
        self.distance = 0
    }
}
