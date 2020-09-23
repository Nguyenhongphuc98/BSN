//
//  FullRadiusShadowButtonStyle.swift
//  BSN
//
//  Created by Phucnh on 9/23/20.
//

import SwiftUI

struct FullRadiusShadowButtonStyle: ButtonStyle {
    
    var bgColor: Color
    
    var isActive: Bool
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 26)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(isActive ? bgColor : Color.clear)
                    .shadow(color: .gray, radius: 2, x: 1, y: 1)
            )
            .animation(.easeInOut(duration: 0.35))
    }
}
