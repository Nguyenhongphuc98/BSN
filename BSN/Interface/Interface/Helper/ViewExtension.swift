//
//  ViewExtension.swift
//  Interface
//
//  Created by Phucnh on 9/29/20.
//

import SwiftUI

extension View {
    
    /// Todo something on this view then return itself
    public func onReload(perform: @escaping () -> Void) -> some View {
        DispatchQueue.main.async {
            perform()
        }
        
        return self
    }
}
