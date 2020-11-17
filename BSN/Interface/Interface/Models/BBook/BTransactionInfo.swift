//
//  BTransactionInfo.swift
//  Interface
//
//  Created by Phucnh on 10/27/20.
//

import SwiftUI

enum ExchangeProgess: String {
    // Just create
    case new
    // Someone sent reuqest ex
    case waiting
    // Owner don't want to exchange
    case decline
    // Owner accept
    case accept
    // Someone cancel request ex
    case cancel
    
    func des() -> String {
        switch self {
        case .new:
            return "tạo mới"
        case .waiting:
            return "đang chờ"
        case .decline:
            return "từ chối"
        case .accept:
            return "chấp nhận"
        case .cancel:
            return "huỷ bỏ"
        }
    }
}

struct BTransactionInfo {

    var exchangeDate: Date?
    
    var numDay: Int?
    
    var adress: String
    
    var message: String
    
    var progess: ExchangeProgess
}
