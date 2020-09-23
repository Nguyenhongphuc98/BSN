//
//  CircleImage.swift
//  BSN
//
//  Created by Phucnh on 9/23/20.
//

import SwiftUI

struct CircleImage: View {
    
    var image: String = "avatar"
    
    var diameter: CGFloat = 50
    
    var body: some View {
        Image(image)
            .resizable()
            .frame(width: diameter, height: diameter)
            .clipShape(Circle())
    }
}

struct CircleImageOptions: View {
    
    var image: String = "avatar"
    
    var strokeColor: Color = Color._primary
    
    var strokeWidth: CGFloat = 3
    
    var diameter: CGFloat = 50
    
    var hasShadow: Bool = false
    
    var shadowx: CGFloat = 1
    
    var shadowy: CGFloat = 1
    
    var body: some View {
        CircleImage(image: image, diameter: diameter)
            .addStroke(color: strokeColor, width: strokeWidth)
            .addShadow(shadow: true, dx: shadowx, dy: shadowy)
    }
}

extension View {
    
    fileprivate func addStroke(color: Color? = nil, width: CGFloat) -> AnyView {
        if let color = color {
            return AnyView(self.overlay(Circle().stroke(lineWidth: width).fill(color)))
        } else {
            return AnyView(self)
        }
    }
    
    fileprivate func addShadow(shadow: Bool, dx: CGFloat, dy: CGFloat) -> AnyView {
        if shadow {
            return AnyView(self.shadow(color: .gray, radius: 5, x: dx, y: dy))
        } else {
            return AnyView(self)
        }
    }
}

struct CircleImage_Previews: PreviewProvider {
    static var previews: some View {
        CircleImage()
    }
}
