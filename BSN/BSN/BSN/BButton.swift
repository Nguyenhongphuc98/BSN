//
//  BButton.swift
//  BSN
//
//  Created by Phucnh on 9/23/20.
//

import SwiftUI

struct BButton<Content: View>: View {
    
    @Binding var isActive: Bool
    
    var invert: Bool = false
    
    var builder: () -> Content
    
    var body: some View {
        Button {
            self.isActive.toggle()
            print("did click BButton")
        } label: {
            builder()
        }
        .buttonStyle(FullRadiusShadowButtonStyle(bgColor: Color.init(hex: 0xF3F3F3), isActive: invert ? !isActive : isActive))
    }
}

extension BButton where Content == Text {
    
    init(isActive: Binding<Bool>, @ViewBuilder builder: @escaping () -> Content) {
        self._isActive = isActive
        self.builder = builder
    }
}
