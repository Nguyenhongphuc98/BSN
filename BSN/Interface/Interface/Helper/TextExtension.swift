//
//  TextExtension.swift
//  Interface
//
//  Created by Phucnh on 9/29/20.
//

import SwiftUI

extension Text {
    
    func robontoBold(size: CGFloat) -> Self {
        self.font(.custom("Roboto-Bold", size: size))
    }
    
    func robontoLightItalic(size: CGFloat) -> Self {
        self.font(.custom("Roboto-LightItalic", size: size))
    }
    
    func robontoLight(size: CGFloat) -> Self {
        self.font(.custom("Roboto-Light", size: size))
    }
    
    func pattayaRegular(size: CGFloat) -> Self {
        self.font(.custom("Pattaya-Regular", size: size))
    }
}

extension TextEditor {
    
    func robontoBold(size: CGFloat) -> some View {
        self.font(.custom("Roboto-Bold", size: size))
    }
}
