//
//  DeclineBorrowBookViewModel.swift
//  Interface
//
//  Created by Phucnh on 10/8/20.
//

import SwiftUI

class DeclineBorrowBookViewModel: ObservableObject {
    
    @Published var declineMessage: String
    
    init() {
            declineMessage = ""
    }
    
    func processDecline(complete: @escaping (Bool) -> Void) {
        complete(true)
    }
}
