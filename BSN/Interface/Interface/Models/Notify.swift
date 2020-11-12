//
//  Notify.swift
//  Interface
//
//  Created by Phucnh on 10/1/20.
//

import SwiftUI
import Business

enum NotifyAction: String, CaseIterable {
    
    case heart
    
    case breakHeart
    
    case comment
    
    case follow
    
    case borrow
    
    case borrowFail
    
    case borrowSuccess
    
    case exchange
    
    case exchangeFail
    
    case exchangeSuccess
    
    func description() -> String {
        
        var des = "Undefine"
        switch self {
        case .heart: des = "thả tim bài viết của bạn"
        case .breakHeart: des = "thả trái tim tãn vỡ bài viết của bạn"
        case .comment: des = "bình luận bài viết của bạn"
        case .follow: des = "theo dõi bạn"
        case .borrow: des = "gửi cho bạn yêu cầu mượn sách"
        case .borrowFail: des = "từ chối yêu cầu mượn sách của bạn"
        case .borrowSuccess: des = "chấp nhận yêu cầu mượn sách của bạn"
        case .exchange: des = "gửi cho bạn yêu cầu đổi sách"
        case .exchangeFail: des = "từ chối yêu cầu đổi sách của bạn"
        case .exchangeSuccess: des = "chấp nhận yêu đổi sách của bạn"
        }
        
        return des
    }
}

// MARK: - Notify base
class Notify: Identifiable {
    
    var id: String
    
    var sender: User
    
    var action: NotifyAction
    
    var destinationID: String
    
    var createDate: Date
    
    @Published var seen: Bool
    
    init() {
        id = UUID().uuidString
        sender = User()
        action = NotifyAction.allCases.randomElement()!
        destinationID = UUID().uuidString
        createDate = fakedates.randomElement()!
        seen = Int.random(in: 0...1) == 0 ? true : false
    }
    
    init(enotify: ENotify) {
        id = enotify.id
        sender = User(id: enotify.actorID, photo: enotify.actorPhoto, name: enotify.actorName)
        action = NotifyAction(rawValue: enotify.notifyName)!
        destinationID = enotify.destionationID
        createDate = Date.getDate(dateStr: enotify.createdAt)
        seen = false
    }
}

extension Notify: Hashable {
    
    static func == (lhs: Notify, rhs: Notify) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        return hasher.combine(self.id)
    }
}
