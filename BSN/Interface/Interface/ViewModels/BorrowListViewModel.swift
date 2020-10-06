//
//  BorrowListViewModel.swift
//  Interface
//
//  Created by Phucnh on 10/6/20.
//

import SwiftUI

class BorrowListViewModel: ObservableObject {
    
    var models: [BorrowBook]
    
    init() {
        models = [BorrowBook(), BorrowBook(), BorrowBook(), BorrowBook(), BorrowBook(), BorrowBook()]
    }
}
