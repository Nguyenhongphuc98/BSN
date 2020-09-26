//
//  CircleImage.swift
//  BSN
//
//  Created by Phucnh on 9/23/20.
//

import SwiftUI

public struct CircleImage: View {
    
    var image: String = "avatar"
    
    var diameter: CGFloat = 50
    
    public var body: some View {
        Image(image, bundle: interfaceBundle)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: diameter, height: diameter)
            .clipShape(Circle())
    }
}

public struct CircleImageOptions: View {
    
    var image: String
    
    var strokeColor: Color
    
    var strokeWidth: CGFloat
    
    var diameter: CGFloat
    
    var hasShadow: Bool
    
    var shadowx: CGFloat
    
    var shadowy: CGFloat
    
    public init(image: String = "avatar",
         strokeColor: Color = Color._online, strokeWidth: CGFloat = 3,
         diameter: CGFloat = 50,
         hasShadow: Bool = false,
         shadowx: CGFloat = 1,
         shadowy: CGFloat = 1) {
        
        self.image = image
        self.strokeColor = strokeColor
        self.strokeWidth = strokeWidth
        self.diameter = diameter
        self.hasShadow = hasShadow
        self.shadowx = shadowx
        self.shadowy = shadowy
    }
    
    public var body: some View {
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
