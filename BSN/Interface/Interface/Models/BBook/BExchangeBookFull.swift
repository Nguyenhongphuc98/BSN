//
//  BExchangeBookFull.swift
//  Interface
//
//  Created by Phucnh on 10/28/20.
//

import SwiftUI

class BExchangeBookFull: BExchangeBook {
    
    var transactionInfo: BTransactionInfo
    
    override init() {
        transactionInfo = BTransactionInfo(
            exchangeDate: Date(),
            numDay: 0,
            adress: "KTX khu A, Đại học quốc gia",
            message: "Bạn ơi cho mình mượn với nhé",
            progess: .new
        )
        super.init()
    }
    
    // init for prepare submit with available transaction
    init(id: String, firstubid: String? = nil, secondubid: String? = nil, firstTitle: String, firstAuthor: String, firstCover: String? = "book_cover", firstOwner: String, firstStatusDes: String, firstStatus: String, secondStatusDes: String?, secondStatus: String?, sencondTitle: String, secondAuthor: String, secondCover: String?) {
        
        transactionInfo = BTransactionInfo(
            exchangeDate: nil,
            numDay: nil,
            adress: "",
            message: "",
            progess: .new
        )
        
        super.init(
            id: id,
            firstubid: firstubid,
            secondubid: secondubid,
            firstTitle: firstTitle,
            firstAuthor: firstAuthor,
            firstCover: firstCover,
            firstOwner: firstOwner,
            firstStatusDes: firstStatusDes,
            firstStatus: firstStatus,
            secondStatusDes: secondStatusDes,
            secondStatus: secondStatus,
            secondTitle: sencondTitle,
            secondAuthor: secondAuthor,
            secondCover: secondCover
        )
    }
    
    // init for accept/decline - view result
    init(id: String, state: String, firstTitle: String, firstAuthor: String, firstCover: String? = "book_cover", firstOwner: String, firstStatusDes: String, secondOwner: String, secondStatusDes: String, sencondTitle: String, secondAuthor: String, secondCover: String?, adress: String, message: String) {
        
        transactionInfo = BTransactionInfo(
            exchangeDate: nil,
            numDay: nil,
            adress: adress,
            message: message,
            progess: ExchangeProgess(rawValue: state)!
        )
        
        super.init(
            id: id,
            firstTitle: firstTitle,
            firstAuthor: firstAuthor,
            firstCover: firstCover,
            firstOwner: firstOwner,
            firstStatusDes: firstStatusDes,
            secondOwner: secondOwner,
            secondStatusDes: secondStatusDes,
            secondTitle: sencondTitle,
            secondAuthor: secondAuthor,
            secondCover: secondCover
        )
    }
}
