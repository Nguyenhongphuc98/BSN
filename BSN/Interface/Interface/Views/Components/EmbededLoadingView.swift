//
//  EmbededLoadingView.swift
//  Interface
//
//  Created by Phucnh on 10/30/20.
//

import SwiftUI

struct EmbededLoadingView: ViewModifier {
    
    @Binding var isLoading: Bool
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if isLoading {
                Loading()
            }
        }
    }
}

extension View {
    
    func embededLoading(isLoading: Binding<Bool>) -> some View {
        self.modifier(EmbededLoadingView(isLoading: isLoading))
    }
}
