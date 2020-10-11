//
//  MyBookDetail.swift
//  Interface
//
//  Created by Phucnh on 10/10/20.
//

import SwiftUI

class MyBookDetail: BookDetail {
    
    @Published var status: BookStatus
    
    @Published var state: BookState
    
    @Published var statusDes: String
    
    override init() {
        statusDes = "Sách tương đối mới, chỉ bị mất 1 tờ số 25"
        state = .available
        status = .new
        super.init()
    }
}
