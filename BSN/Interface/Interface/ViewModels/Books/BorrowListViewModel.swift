//
//  BorrowListViewModel.swift
//  Interface
//
//  Created by Phucnh on 10/6/20.
//

import SwiftUI

class BorrowListViewModel: ObservableObject {
    
    var models: [BAvailableTransaction]
    
    init() {
        models = [BAvailableTransaction(), BAvailableTransaction(), BAvailableTransaction(), BAvailableTransaction(), BAvailableTransaction(), BAvailableTransaction()]
    }
}
