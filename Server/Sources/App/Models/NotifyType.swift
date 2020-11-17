//
//  NotifyType.swift
//  
//
//  Created by Phucnh on 10/17/20.
//

import Fluent
import Vapor

final class NotifyType: Model {
    
    static let schema = "notify_type"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    init() { }
    
    init(id: UUID? = nil, name: String) {
        self.id = id
        self.name = name
    }
}

extension NotifyType: Content { }

// MARK: - Quick ID Query
extension NotifyType {
    var heart: String { "6C05BF68-A710-40E3-9384-F4D613D67FA5" }
    var breakHeart: String { "5CD9D139-C3A5-4EED-8B7B-711959F8401F" }
    var comment: String { "08147F52-2A26-49C2-B64D-19C3B63C26C2" }
    var follow: String { "CA3B21D8-A813-4AEB-9256-DF5C547F1548" }
    var borrow: String { "208F948B-E3F4-4F33-98A0-0D17976180DD" }
    var borrowFail: String { "4E1B5CEB-9AE7-4860-909D-E0CF2CF5EE38" }
    var borrowSuccess: String { "40681E22-D7BA-4880-B9C0-EDED4C228FD9" }
    var exchange: String { "B5C0EA0E-EAF6-47DC-A15B-12869159F875" }
    var exchangeFail: String { "3137A160-3DA1-40AF-857C-83DD728739D4" }
    var exchangeSuccess: String { "04FF8F1C-1199-415A-A83F-282C35909D49" }
}
