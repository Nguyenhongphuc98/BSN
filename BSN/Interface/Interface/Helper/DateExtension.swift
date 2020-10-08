//
//  DateExtension.swift
//  Interface
//
//  Created by Phucnh on 10/8/20.
//

import SwiftUI

extension Date {
   func getDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
}
