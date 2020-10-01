//
//  Notify.swift
//  Interface
//
//  Created by Phucnh on 10/1/20.
//

import SwiftUI

enum NotifyAction: Int {
    
    case heart
    
    case breakHeart
    
    case comment
    
    case following
    
    case borrowBook
    
    case exchangeBook
    
    func description() -> String {
        
        var des = "Undefine"
        switch self {
        case .heart: des = "thả tim bài viết của bạn"
        case .breakHeart: des = "thả trái tim tãn vỡ bài viết của bạn"
        case .comment: des = "bình luận bài viết của bạn"
        case .following: des = "theo dõi bạn"
        case .borrowBook: des = "gửi cho bạn yêu cầu mượn sách"
        case .exchangeBook: des = "gửi cho bạn yêu cầu đổi sách"
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
        action = NotifyAction(rawValue: Int.random(in: 0...5))!
        destinationID = UUID().uuidString
        createDate = randomDate()
        seen = Int.random(in: 0...1) == 0 ? true : false
    }
}
