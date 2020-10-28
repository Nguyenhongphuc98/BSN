//
//  InputWithTitle.swift
//  Interface
//
//  Created by Phucnh on 10/8/20.
//

import SwiftUI

struct InputWithTitle: View {
    
    @Binding var content: String
    
    var placeHolder: String
    
    var title: String
    
    var keyboardType: UIKeyboardType = .default
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
            
            TextField(placeHolder, text: $content)
                .keyboardType(keyboardType)
                .padding(10)
                .background(Color.white.cornerRadius(10))
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.init(hex: 0xC4C4C4)))
        }
    }
}

//struct InputWithTitle_Previews: PreviewProvider {
//    static var previews: some View {
//        InputWithTitle()
//    }
//}
