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
}
