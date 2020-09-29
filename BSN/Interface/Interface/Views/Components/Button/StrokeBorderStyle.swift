//
//  TagButtonStyle.swift
//  Interface
//
//  Created by Phucnh on 9/29/20.
//

import SwiftUI

struct StrokeBorderStyle: ButtonStyle {
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(.vertical, 3)
            .padding(.horizontal, 5)
            .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.init(hex: 0xBFB9B9), lineWidth: 1))
            .background(RoundedRectangle(cornerRadius: 5).fill(configuration.isPressed ? Color.gray : Color.white))
            .clipped()
    }
}
