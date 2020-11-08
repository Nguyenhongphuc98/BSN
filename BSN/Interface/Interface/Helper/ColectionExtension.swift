//
//  ColectionExtension.swift
//  Interface
//
//  Created by Phucnh on 11/3/20.
//

import Foundation

extension Array where Element: Identifiable & Hashable {
    
    mutating func appendUnique(item: Element) {
        //print("receive id:", item.id)
        let index = self.firstIndex { $0 == item }
        if index != nil { return }
        print("add id:", item.id)
        self.append(item)
    }
}
