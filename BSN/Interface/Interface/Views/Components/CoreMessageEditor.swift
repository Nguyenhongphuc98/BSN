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
            EditorWithPlaceHolder(
                text: $message,
                placeHolder: placeHolder,
                background: Color(.secondarySystemBackground),
                font: "Roboto-LightItalic"
            )
            .frame(height: 40)
            .clipShape(Capsule())
            
            if message != "" {
                
                Button(action: {
                    didEnter?(message)
                    message = ""
                }, label: {
                    Image(systemName: "paperplane.fill")
                        .font(.system(size: 22))
                        .rotationEffect(.init(degrees: 45))
                        .padding(.all, 8)
                        .background(Color(.secondarySystemBackground))
                        .clipShape(Circle())
                })
            }
        }
        .animation(.easeOut)
    }
}

struct CoreMessageEditor_Previews: PreviewProvider {
    static var previews: some View {
        CoreMessageEditor(placeHolder: "Để lại bình luận") { (success) in
            print("did send: \(success)")
        }
    }
}
