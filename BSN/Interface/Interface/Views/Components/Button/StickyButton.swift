//
//  StickyButton.swift
//  Interface
//
//  Created by Phucnh on 9/28/20.
//

import SwiftUI

// MARK: - Sticky button
struct StickyButton<Content: View>: View {
    
    @State var active: Bool = false
    
    var content: Content
    
    var didChangeState: ((Bool) -> Void)?
    
    init(@ViewBuilder content: () -> Content,
                      active: Bool = false,
                      didChange: ((Bool) -> Void)? = nil) {
        
        self.content = content()
        self.didChangeState = didChange
        self.active = active
    }
    
    var body: some View {
        Button(action: {
            self.didChangeState?(active)
        }, label: {
            content
        })
    }
}

struct StickyImageButton: View {
    
    @Binding var isActive: Bool
    
    var normalIcon: String
    
    var activeIcon: String
    
    var color: Color = .primary
    
    var size: CGSize = .zero
    
    var didChangeState: ((Bool) -> Void)?
    
    init(normal: String,
         active: String,
         color: Color = .primary,
         size: CGSize = CGSize(width: 22, height: 22),
         isActive: Binding<Bool>,
         didChange: ((Bool) -> Void)? = nil) {
        
        self.normalIcon = normal
        self.activeIcon = active
        self._isActive = isActive
        self.color = color
        self.size = size
        self.didChangeState = didChange
    }
    
    var body: some View {
        Button(action: {
            isActive.toggle()
            self.didChangeState?(isActive)
        }, label: {
            Image(systemName: isActive ? activeIcon : normalIcon)
                .foregroundColor(color)
        })
        .buttonStyle(PlainButtonStyle())
    }
}
