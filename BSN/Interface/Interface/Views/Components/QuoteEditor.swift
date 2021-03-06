//
//  QuoteEditor.swift
//  Interface
//
//  Created by Phucnh on 9/29/20.
//

import SwiftUI

// MARK: - Quote Editor
struct QuoteEditor: View {
    
    @Binding var message: String
    
    var body: some View {
        HStack {
            Rectangle()
                .fill(Color.init(hex: 0xAEA6A6))
                .frame(width: 3, height: 70)
            
            EditorWithPlaceHolder(text: $message, placeHolder: "Để lại trích dẫn yêu thích")
                .frame(height: 70)
        }
        .padding(.leading, 30)
    }
}

struct QuoteEditor_Previews: PreviewProvider {
    
    @State static var message: String = ""
    static var previews: some View {
        QuoteEditor(message: $message)
    }
}

// MARK: - Core Editor
struct EditorWithPlaceHolder: View {
    
    @Binding var text: String
    
    var placeHolder: String
    
    var bg: Color
    
    var forcegroundColor: Color
    
    var font: String
    
    init(text: Binding<String>, placeHolder: String,
         background: Color = .white,
         forceground: Color = .init(hex: 0x868686),
         font: String = "Roboto-Bold") {
        
        self._text = text
        self.placeHolder = placeHolder
        self.bg = background
        self.forcegroundColor = forceground
        self.font = font
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            if text == "" {
                Text(placeHolder)
                    .bFont(name: font, size: 13)
                    .foregroundColor(.gray)
                    .padding(4)
                    .padding(.top, 6)
                    .disabled(true)
                    .allowsHitTesting(false)
            }
            
            TextEditor(text: self.$text)
                .bFont(name: font, size: 13)
                .foregroundColor(forcegroundColor)
                //.background(Color.pink)            
        }
        .padding(.leading, 10)
        .background(bg)
    }
}

//struct MultilineTextView: UIViewRepresentable {
//    @Binding var text: String
//
//    func makeUIView(context: Context) -> UITextView {
//        let view = UITextView()
//        view.isScrollEnabled = true
//        view.isEditable = true
//        view.isUserInteractionEnabled = true
//        return view
//    }
//
//    func updateUIView(_ uiView: UITextView, context: Context) {
//        uiView.text = text
//    }
//}
