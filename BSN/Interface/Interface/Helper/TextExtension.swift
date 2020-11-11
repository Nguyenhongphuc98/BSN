//
//  TextExtension.swift
//  Interface
//
//  Created by Phucnh on 9/29/20.
//

import SwiftUI

extension Text {
    
    public func roboto(size: CGFloat) -> Self {
        self.font(.custom("Roboto-Regular", size: size))
    }
    
    public func robotoItalic(size: CGFloat) -> Self {
        self.font(.custom("Roboto-Italic", size: size))
    }
    
    public func robotoBold(size: CGFloat) -> Self {
        self.font(.custom("Roboto-Bold", size: size))
    }
    
    public func robotoLightItalic(size: CGFloat) -> Self {
        self.font(.custom("Roboto-LightItalic", size: size))
    }
    
    public func robotoLight(size: CGFloat) -> Self {
        self.font(.custom("Roboto-Light", size: size))
    }
    
    public func robotoMedium(size: CGFloat) -> Self {
        self.font(.custom("Roboto-Medium", size: size))
    }
    
    public func pattaya(size: CGFloat) -> Self {
        self.font(.custom("Pattaya-Regular", size: size))
    }
    
    public func bFont(name: String, size: CGFloat) -> Self {
        self.font(.custom(name, size: size))
    }
}

extension TextEditor {

    public func robontoBold(size: CGFloat) -> some View {
        self.font(.custom("Roboto-Bold", size: size))
    }
    
    public func bFont(name: String, size: CGFloat) -> some View {
        self.font(.custom(name, size: size))
    }
}
