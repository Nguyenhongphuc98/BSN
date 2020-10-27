//
//  BUserBook.swift
//  Interface
//
//  Created by Phucnh on 10/27/20.
//

import SwiftUI

class BUserBook: BBook {
    
    var ownerName: String?
    
    var ownerID: String?
    
    var status: BookStatus
    
    var state: BookState
    
    var statusDes: String
    
    override init() {
        status = .likeNew
        state = .available
        statusDes = "Như mới"
        super.init()
    }
}
