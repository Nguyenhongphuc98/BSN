//
//  TextExtension.swift
//  Interface
//
//  Created by Phucnh on 9/29/20.
//

import SwiftUI

extension Text {
    
    func roboto(size: CGFloat) -> Self {
        self.font(.custom("Roboto-Regular", size: size))
    }
    
    func robotoItalic(size: CGFloat) -> Self {
        self.font(.custom("Roboto-Italic", size: size))
    }
    
    func robotoBold(size: CGFloat) -> Self {
        self.font(.custom("Roboto-Bold", size: size))
    }
    
    func robotoLightItalic(size: CGFloat) -> Self {
        self.font(.custom("Roboto-LightItalic", size: size))
    }
    
    func robotoLight(size: CGFloat) -> Self {
        self.font(.custom("Roboto-Light", size: size))
    }
    
    func robotoMedium(size: CGFloat) -> Self {
        self.font(.custom("Roboto-Medium", size: size))
    }
    
    func pattaya(size: CGFloat) -> Self {
        self.font(.custom("Pattaya-Regular", size: size))
    }
    
    func bFont(name: String, size: CGFloat) -> Self {
        self.font(.custom(name, size: size))
    }
}

extension TextEditor {

    func robontoBold(size: CGFloat) -> some View {
        self.font(.custom("Roboto-Bold", size: size))
    }
    
    func bFont(name: String, size: CGFloat) -> some View {
        self.font(.custom(name, size: size))
    }
}
