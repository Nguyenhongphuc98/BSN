//
//  ColectionExtension.swift
//  Interface
//
//  Created by Phucnh on 11/3/20.
//

import Foundation

extension Array where Element: Identifiable & Hashable {
    
    mutating func appendUnique(item: Element) {
        let index = self.firstIndex { $0 == item }
        if index != nil { return }
        self.append(item)
    }
    
    mutating func insertUnique(item: Element) {
        let index = self.firstIndex { $0 == item }
        if index != nil { return }
        self.insert(item, at: 0)
    }
}

protocol AppendUniqueAble: Hashable, Identifiable {
 
}

extension AppendUniqueAble {
    static public func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(self.id)
    }
}
