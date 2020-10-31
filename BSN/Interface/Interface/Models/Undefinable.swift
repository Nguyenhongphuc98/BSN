//
//  Undefinable.swift
//  Interface
//
//  Created by Phucnh on 10/31/20.
//

let kUndefine = "undefine"
protocol Undefinable: Identifiable {
}

extension Undefinable where Self.ID == String{
    func isUndefine() -> Bool {
        id == kUndefine
    }
}
