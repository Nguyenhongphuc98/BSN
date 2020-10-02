//
//  CoreMessageEditor.swift
//  Interface
//
//  Created by Phucnh on 10/1/20.
//

import SwiftUI

struct CoreMessageEditor: View {
    
    @State private var message: String = ""
    
    var placeHolder: String
    
    var didEnter: ((String) -> Void)?
    
    var body: some View {
        HStack {
            EditorWithPlaceHolder(text: $message, placeHolder: placeHolder, font: "Roboto-LightItalic")
                .frame(height: 40)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .clipped()
                .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.gray))
                .padding(.vertical, 3)
            
            Button(action: {
                didEnter?(message)
                message = ""
            }, label: {
                Image(systemName: "arrow.right.circle.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(message == "" ? .gray : ._primary)
                    .padding()
            })
        }
        .background(Color._receiveMessage)
    }
}

struct CoreMessageEditor_Previews: PreviewProvider {
    static var previews: some View {
        CoreMessageEditor(placeHolder: "Để lại bình luận") { (success) in
            print("did send: \(success)")
        }
    }
}
