//
//  BorowBook.swift
//  Interface
//
//  Created by Phucnh on 10/6/20.
//

import SwiftUI

class BorrowBook: Identifiable {
    
    var id: String
    
    var owner: User
    
    var distance: Float // in Met unit
    
    var status: BookStatus
    
    init() {
        id = UUID().uuidString
        owner = User()
        distance = Float.random(in: 0..<5000)
        status = BookStatus.allCases.randomElement()!
    }
}
