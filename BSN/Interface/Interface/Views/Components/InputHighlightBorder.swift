//
//  InputHighlightBorder.swift
//  Interface
//
//  Created by Phucnh on 1/9/21.
//

import SwiftUI

struct InputHighlightBorder: View {
    
    @Binding var content: String
    
    var placer: String
    
    var contentType: UITextContentType = .name
    var keyboardType: UIKeyboardType = .numberPad
    
    var body: some View {
        TextField(placer, text: $content)
            .textContentType(contentType)
            .keyboardType(keyboardType)
            .padding(5)
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .strokeBorder(borderColor, lineWidth: 1)
            )
            .foregroundColor(borderColor)
    }
    
    var borderColor: Color {
        content.isEmpty ? .gray : .blue
    }
}

//struct InputHighlightBorder_Previews: PreviewProvider {
//    static var previews: some View {
//        InputHighlightBorder()
//    }
//}
