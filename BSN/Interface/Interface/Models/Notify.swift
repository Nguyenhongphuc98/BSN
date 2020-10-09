//
//  Notify.swift
//  Interface
//
//  Created by Phucnh on 10/1/20.
//

import SwiftUI

enum NotifyAction: Int, CaseIterable {
    
    case heart
    
    case breakHeart
    
    case comment
    
    case following
    
    case borrowBook
    
    case borrowFail
    
    case borrowSuccess
    
    case exchangeBook
    
    case exchangeFail
    
    case exchangeSuccess
    
    func description() -> String {
        
        var des = "Undefine"
        switch self {
        case .heart: des = "thả tim bài viết của bạn"
        case .breakHeart: des = "thả trái tim tãn vỡ bài viết của bạn"
        case .comment: des = "bình luận bài viết của bạn"
        case .following: des = "theo dõi bạn"
        case .borrowBook: des = "gửi cho bạn yêu cầu mượn sách"
        case .borrowFail: des = "từ chối yêu cầu mượn sách của bạn"
        case .borrowSuccess: des = "chấp nhận yêu cầu mượn sách của bạn"
        case .exchangeBook: des = "gửi cho bạn yêu cầu đổi sách"
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
    
    var receive: User
    
    var action: NotifyAction
    
    var destinationID: String
    
    var createDate: Date
    
    @Published var seen: Bool
    
    init() {
        id = UUID().uuidString
        sender = User()
        receive = User()
        action = NotifyAction.allCases.randomElement()!
        destinationID = UUID().uuidString
        createDate = randomDate()
        seen = Int.random(in: 0...1) == 0 ? true : false
    }
}
