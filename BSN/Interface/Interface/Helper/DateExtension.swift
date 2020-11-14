//
//  DateExtension.swift
//  Interface
//
//  Created by Phucnh on 10/8/20.
//

import SwiftUI

extension Date {
    func getDateStr(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
    
    static func getDate(dateStr: String? = nil) -> Date {
        guard let str = dateStr else {
            return Date()
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        return dateFormatter.date(from: str) ?? dateFormatter2.date(from: str)!
    }
}
