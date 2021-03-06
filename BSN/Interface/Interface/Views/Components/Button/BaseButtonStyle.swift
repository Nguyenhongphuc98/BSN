//
//  PrimaryButtonStyle.swift
//  Interface
//
//  Created by Phucnh on 10/5/20.
//

import SwiftUI

public enum ButtonSize {
    case small
    case medium
    case large
    
    // Medium but expand to horizontal more than usual
    case mediumH
    
    // Large but expand to horizontal more than usual
    case largeH
    
    func getH() -> CGFloat {
        switch self {
        case .small:
            return 15
        case .medium:
            return 20
        case .large:
            return 30
        case .mediumH:
            return 40
        case .largeH:
            return 40
        }
    }
    
    func getV() -> CGFloat {
        switch self {
        case .small:
            return 4
        case .medium, .mediumH:
            return 7
        case .large, .largeH:
            return 12
        }
    }
}

public enum ButtonType {
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

struct BaseButton: View {
    
    let configuration: ButtonStyle.Configuration
    
    var size: ButtonSize = .small
    
    var type: ButtonType = .primary
    
    @Environment(\.isEnabled) private var isEnabled: Bool
    
    var body: some View {
        configuration.label
            .foregroundColor(type.forceground())
            .padding(.vertical, size.getV())
            .padding(.horizontal, size.getH())
            .background(RoundedRectangle(cornerRadius: 5).fill(isEnabled ? type.background().opacity(configuration.isPressed ? 0.7 : 1) : Color.gray))
            .clipped()
    }
}

// MARK: - Button Style
public struct BaseButtonStyle: ButtonStyle {
    
    var size: ButtonSize
    
    var type: ButtonType
    
    public init(size: ButtonSize = .small, type: ButtonType = .primary) {
        self.size = size
        self.type = type
    }
    
    public func makeBody(configuration: ButtonStyle.Configuration) -> some View {
        BaseButton(configuration: configuration, size: size, type: type)
    }
}

public struct RoundButtonStyle: ButtonStyle {
    
    var size: ButtonSize
    
    var type: ButtonType
    
    public init(size: ButtonSize = .small, type: ButtonType = .primary) {
        self.size = size
        self.type = type
    }
    
    public func makeBody(configuration: ButtonStyle.Configuration) -> some View {
        BaseButton(configuration: configuration, size: size, type: type)
            .clipShape(Capsule())
    }
}
