//
//  SubmitAddBookViewModel.swift
//  Interface
//
//  Created by Phucnh on 10/11/20.
//

import SwiftUI

class SubmitAddBookViewModel: ObservableObject {
    
    @Published var model: MyBookDetail
    
    @Published var bookCode: String
    
    init() {
        model = MyBookDetail()
        bookCode = "XBDFS"
    }
    
    func addBook(complete: @escaping (Bool) -> Void) {
        complete(true)
    }
}
