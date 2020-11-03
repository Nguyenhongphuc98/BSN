//
//  ColectionExtension.swift
//  Interface
//
//  Created by Phucnh on 11/3/20.
//

import Foundation

extension Array where Element: Hashable {
    
    mutating func appendUnique(item: Element) {
        let index = self.firstIndex { $0 == item }
        if index != nil { return }
        self.append(item)
    }
}
