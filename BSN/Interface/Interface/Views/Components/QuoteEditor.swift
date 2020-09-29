//
//  QuoteEditor.swift
//  Interface
//
//  Created by Phucnh on 9/29/20.
//

import SwiftUI

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
        .padding(.horizontal, 20)
    }
}

struct QuoteEditor_Previews: PreviewProvider {
    
    @State static var message: String = ""
    static var previews: some View {
        QuoteEditor(message: $message)
    }
}

struct EditorWithPlaceHolder: View {
    
    @Binding var text: String
    
    var placeHolder: String
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            TextEditor(text: self.$text)
                .robontoBold(size: 13)
                .foregroundColor(.init(hex: 0x868686))
            
            if text == "" {
                Text(placeHolder)
                    .robontoBold(size: 13)
                    .foregroundColor(.gray)
                    .padding(4)
                    .padding(.top, 6)
                    .allowsHitTesting(false)
            }
        }
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
