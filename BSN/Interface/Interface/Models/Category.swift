//
//  Category.swift
//  Interface
//
//  Created by Phucnh on 11/23/20.
//

import Foundation

class Category: ObservableObject, Identifiable {
    var id: String
    var name: String
    
    // in seting interest category
    @Published var interested: Bool
    
    init(id: String, name: String, interested: Bool = false) {
        self.id = id
        self.name = name
        self.interested = interested
    }
}

extension Category: Hashable {
    static public func == (lhs: Category, rhs: Category) -> Bool {
        return lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(self.id)
    }
}
