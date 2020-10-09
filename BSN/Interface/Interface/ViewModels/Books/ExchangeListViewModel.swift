//
//  ExchangeListViewModel.swift
//  Interface
//
//  Created by Phucnh on 10/9/20.
//

import SwiftUI

// Manage list show in list exchange books list (seperate view)
class ExchangeListViewModel: ObservableObject {
    
    var models: [ExchangeBook4C]
    
    init() {
        models = [ExchangeBook4C(), ExchangeBook4C(), ExchangeBook4C(), ExchangeBook4C(), ExchangeBook4C(), ExchangeBook4C()]
    }
}
