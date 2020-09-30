//
//  ViewExtension.swift
//  Interface
//
//  Created by Phucnh on 9/29/20.
//

import SwiftUI

// MARK: - Perform function
extension View {
    
    /// Todo something on this view then return itself
    public func onReload(perform: @escaping () -> Void) -> some View {
        DispatchQueue.main.async {
            perform()
        }
        
        return self
    }
}

// MARK: - Decorate View
extension View {
    
    /// Add navigationView in logic but not show
    /// Avoid arrow in List
    func navigationLink<Destination: View>(destination: Destination) -> some View {
        background(
            NavigationLink(destination: destination) {
                EmptyView()
            }
            .frame(width: 0, height: 0)
            .opacity(0)
        )
    }
    
}
