//
//  ExchangeBook.swift
//  Business
//
//  Created by Phucnh on 10/30/20.
//

public struct ExchangeBook: Codable {
    
    public var id: String?
    
    public var firstUserBookID: String
    
    public var exchangeBookID: String
    
    public var secondUserBookID: String?
    
    public var adress: String?
    
    public var message: String?
    
    public var firstStatusDes: String?
    
    public var secondStatusDes: String?
    
    public var state: String
    
    public init() {
        
        self.firstUserBookID = "undefine"
        self.exchangeBookID = "undefine"
        self.state = "new"
    }
    
    public init(id: String? = nil, firstUserBookID: String, exchangeBookID: String,
                secondUserBookID: String? = nil, adress: String? = nil, message: String? = nil,
                firstStatusDes: String? = nil, secondStatusDes: String? = nil, state: String) {
        
        self.id = id
        self.firstUserBookID = firstUserBookID
        self.exchangeBookID = exchangeBookID
        self.secondUserBookID = secondUserBookID
        self.adress = adress
        self.message = message
        self.firstStatusDes = firstStatusDes
        self.secondStatusDes = secondStatusDes
        self.state = state
    }
}
