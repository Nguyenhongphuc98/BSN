//
//  MyBookDetailViewModel.swift
//  Interface
//
//  Created by Phucnh on 10/10/20.
//

import SwiftUI

class MyBookDetailViewModel: ObservableObject {
    
    var model: MyBookDetail
    
    init() {
        model = MyBookDetail()
    }
}
