//
//  History.swift
//  Interface
//
//  Created by Phucnh on 12/17/20.
//

import SwiftUI
import Business

class History: ObservableObject, AppendUniqueAble {
    
    var id: String // id of borrow or exchange
    var bookTitle: String
    var partnerName: String
    var time: Date
    var type: HistoryCardType
    
    @Published var style: HistoryCardStyle
    
    let bbManager: BorrowBookManager = .sharedCancel
    let ebManager: ExchangeBookManager = .sharedCancel
    
    init(type: HistoryCardType,id: String, title: String, borrower: String, owner: String, requesterID: String, time: String, state: ExchangeProgess) {
        
        self.type = type
        self.id = id
        self.bookTitle = title
        self.partnerName = requesterID == AppManager.shared.currenUID ? owner : borrower
        self.time = Date.getDate(dateStr: time)
        
        switch state {
        case .new:
            style = .new
        case .waiting:
            style = requesterID == AppManager.shared.currenUID ? .uwaiting : .pwaiting
        case .accept:
            style = requesterID == AppManager.shared.currenUID ? .paccepted : .uaccepted
        case .decline:
            style = requesterID == AppManager.shared.currenUID ? .pdeclined : .udeclined
        case .cancel:
            style = requesterID == AppManager.shared.currenUID ? .ucancel : .pcancel
        }
    }
    
    func cancelRequest() {
        if type == .borrow {
            /// cancel borrow req
            self.bbManager.cancelBorrowReq(bbId: self.id)
        } else {
            /// cancel create exchaning or cancel req exchange
            /// It process same func, depen on current user and state will be excute exactly
            /// What we want
            self.ebManager.cancelExchangeReq(ebId: self.id)
        }
        self.style = .ucancel
    }
}

enum HistoryCardStyle: String {
    case new // exchange, just create
    case uwaiting // waiting for accept or decline - you
    case pwaiting // waiting for accept or decline - partner
    case udeclined
    case pdeclined
    case uaccepted
    case paccepted
    case ucancel // requester cancel
    case pcancel
    
    func icon() -> String {
        switch self {
        case .new, .pwaiting, .udeclined, .uaccepted, .pcancel:
            return "arrow.right"
        case .uwaiting, .pdeclined, .paccepted, .ucancel:
            return "arrow.left"
        }
    }
    
    func color() -> Color {
        switch self {
        case .new:
            return .green
        case .pwaiting, .uwaiting:
            return .yellow
        case .udeclined, .pdeclined:
            return .orange
        case .uaccepted, .paccepted:
            return .blue
        case .pcancel, .ucancel:
            return .red
        }
    }
    
    func des() -> String {
        switch self {
        case .new:
            return "New"
        case .uwaiting, .pwaiting:
            return "Waiting"
        case .udeclined, .pdeclined:
            return "Declined"
        case .uaccepted, .paccepted:
            return "Accepted"
        case .ucancel, .pcancel:
            return "Canceled"
        }
    }
}

enum HistoryCardType: String {
    case borrow
    case exchange
}
