//
//  PrimaryButtonStyle.swift
//  Interface
//
//  Created by Phucnh on 10/5/20.
//

import SwiftUI

enum ButtonSize {
    case small
    case medium
    case large
    
    func getH() -> CGFloat {
        switch self {
        case .small:
            return 15
        case .medium:
            return 20
        case .large:
            return 30
        }
    }
    
    func getV() -> CGFloat {
        switch self {
        case .small:
            return 4
        case .medium:
            return 7
        case .large:
            return 12
        }
    }
}

enum ButtonType {
    case primary
    case secondary
    
    func forceground() -> Color {
        switch self {
        case .primary:
            return .white
        case .secondary:
            return .black
        }
    }
    
    func background() -> Color {
        switch self {
        case .primary:
            return ._primary
        case .secondary:
            return .init(.secondarySystemBackground)
        }
    }
}

// MARK: - Button Style
struct BaseButtonStyle: ButtonStyle {
    
    var size: ButtonSize = .small
    
    var type: ButtonType = .primary
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(type.forceground())
            .padding(.vertical, size.getV())
            .padding(.horizontal, size.getH())
            .background(RoundedRectangle(cornerRadius: 5).fill(type.background().opacity(configuration.isPressed ? 0.7 : 1)))
            .clipped()
            .shadow(radius: 1)
    }
}
