//
//  EmbededLoadingView.swift
//  Interface
//
//  Created by Phucnh on 10/30/20.
//

import SwiftUI

// MARK: - Defaul loading hub
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
    
    public func embededLoading(isLoading: Binding<Bool>) -> some View {
        self.modifier(EmbededLoadingView(isLoading: isLoading))
    }
}

// MARK: - Full screen loading
struct EmbededLoadingFullView: ViewModifier {
    
    @Binding var isLoading: Bool
    
    func body(content: Content) -> some View {
        GeometryReader(content: { geometry in
            ZStack {
                content
                
                if isLoading {
                    LoadingFullScreen()                        
                }
            }
        })
    }
}

extension View {
    
    public func embededLoadingFull(isLoading: Binding<Bool>) -> some View {
        self.modifier(EmbededLoadingFullView(isLoading: isLoading))
    }
}
