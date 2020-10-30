//
//  NavigationState.swift
//  Interface
//
//  Created by Phucnh on 10/30/20.
//

import SwiftUI

public enum ViewName: String {
    case profileRoot
    case undefine
}

protocol PopToable {
    var viewName: ViewName { get set }
}

public class NavigationState: ObservableObject {
    
    @Published var viewName: ViewName
    
    public init() {
        viewName = .undefine
    }
    
    public func popTo(viewName: ViewName) {
        self.viewName = viewName
    }
}
