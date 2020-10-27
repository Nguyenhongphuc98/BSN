//
//  BTransactionInfo.swift
//  Interface
//
//  Created by Phucnh on 10/27/20.
//

import SwiftUI

enum ExchangeProgess {
    case new
    case decline
    case accept
    case cancel
}

struct BTransactionInfo {

    var exchangeDate: Date?
    
    var numDay: Int?
    
    var adress: String
    
    var message: String
    
    var progess: ExchangeProgess
}
