//
//  MyBookDetail.swift
//  Interface
//
//  Created by Phucnh on 10/10/20.
//

import SwiftUI

class MyBookDetail: BookDetail {
    
    var status: BookStatus
    
    var state: BookState
    
    var statusDes: String
    
    var notes: [Note]
    
    override init() {
        statusDes = "Sách tương đối mới, chỉ bị mất 1 tờ số 25"
        state = .available
        status = .new
        notes = [Note(), Note()]
        super.init()
    }
}
