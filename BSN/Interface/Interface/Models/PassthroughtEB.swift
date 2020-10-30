//
//  PassthroughtEB.swift
//  Interface
//
//  Created by Phucnh on 10/30/20.
//

import SwiftUI

/// Object pass to many view to get all info
/// Then process in final view
class PassthroughtEB: ObservableObject {
    
    var needChangeUB: BUserBook
    
    var wantChangeBook: BBook?
    
    init(userBook: BUserBook) {
        self.needChangeUB = userBook
    }
    
    func addBook(book: BBook) -> Self {
        self.wantChangeBook = book
        return self
    }
}
