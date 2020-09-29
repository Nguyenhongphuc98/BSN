//
//  Seperator.swift
//  Interface
//
//  Created by Phucnh on 9/29/20.
//

import SwiftUI

struct Separator: View {
    
    let color: Color
    
    let height: CGFloat
    
    var body: some View {
        Rectangle()
            .fill(color)
            .frame(height: height)
            .padding(.zero)
    }
    
    init(color: Color = Color.init(hex: 0xECE7E7), height: CGFloat = 4) {
        self.color = color
        self.height = height
    }
}

struct Separator_Previews: PreviewProvider {
    static var previews: some View {
        Separator()
    }
}
