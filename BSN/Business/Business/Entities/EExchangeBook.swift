//
//  ExchangeBook.swift
//  Business
//
//  Created by Phucnh on 10/30/20.
//

public class EExchangeBook: Codable {
    
    public var id: String?
    
    public var firstUserBookID: String?
    
    public var exchangeBookID: String?
    
    public var secondUserBookID: String?
    
    // transaction adress
    public var adress: String?
    
    public var message: String?
    
    public var firstStatusDes: String?
    
    public var secondBookID: String?
    
    public var secondStatusDes: String?
    
    public var state: String?
    
    // Addition properties
    public var firstTitle: String?
    
    public var firstAuthor: String?
    
    public var firstCover: String?
    
    // Location of exchanger
    public var location: String?
    
    public var secondTitle: String?
    
    public var secondAuthor: String?
    
    // Should fill when view detail
    public var firstOwnerName: String?
    
    public var firstUserID: String?
    
    // avatar of owner first user-book
    public var firstAvatar: String?
    
    public var firstStatus: String?
    
    public var secondOwnerName: String?
    
    public var firstBookID: String?
    
    public var secondStatus: String?
    
    public var secondCover: String?
    
    public var secondUserID: String?
    
    public var updatedAt: String?
    
//    public var firstubid: String?
//
//    public var secondubid: String?
    
    public init() {
        self.id = "undefine"
        self.firstUserBookID = "undefine"
        self.exchangeBookID = "undefine"
        self.state = "new"
    }
    
    public init(id: String? = nil, firstUserBookID: String? = nil, exchangeBookID: String? = nil,
                secondUserBookID: String? = nil, adress: String? = nil, message: String? = nil,
                firstStatusDes: String? = nil, secondStatusDes: String? = nil, state: String,
                firstTitle: String? = nil, firstAuthor: String? = nil, firstCover: String? = nil, location: String? = nil, secondTitle: String? = nil, secondAuthor: String? = nil, firstOwnerName: String? = nil, secondStatus: String? = nil) {
        
        self.id = id
        self.firstUserBookID = firstUserBookID
        self.exchangeBookID = exchangeBookID
        self.secondUserBookID = secondUserBookID
        self.adress = adress
        self.message = message
        self.firstStatusDes = firstStatusDes
        self.secondStatusDes = secondStatusDes
        self.state = state
        
        self.firstTitle = firstTitle
        self.firstAuthor = firstAuthor
        self.firstCover = firstCover
        self.location = location
        self.secondTitle = secondTitle
        self.secondAuthor = secondAuthor
        self.firstOwnerName = firstOwnerName
        self.secondStatus = secondStatus
        
//        self.firstubid = firstubid
//        self.secondubid = secondubid
    }
}
