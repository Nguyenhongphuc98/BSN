//
//  ColorExtension.swift
//  Interface
//
//  Created by Phucnh on 9/23/20.
//

import Foundation
import SwiftUI

// MARK: - Palette
public extension Color {
    
    static var _primary: Color = Color(hex: 0x2A66FD)
    
    static var _secondary: Color = Color(hex: 0x298DEA)
}

// MARK: - init method
extension Color {
    public init(hex: Int, alpha: Double = 1) {
            self.init(
                .sRGB,
                red: Double((hex >> 16) & 0xff) / 255,
                green: Double((hex >> 08) & 0xff) / 255,
                blue: Double((hex >> 00) & 0xff) / 255,
                opacity: alpha
            )
        }
}
