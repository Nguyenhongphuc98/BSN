//
//  DestinationNotFoundView.swift
//  Interface
//
//  Created by Phucnh on 10/1/20.
//

import SwiftUI

struct ExceptionView: View {
    
    var sign: String
    
    var message: String
    
    var color: Color = .yellow
    
    var body: some View {
        VStack {
            Spacer()
            
            Image(systemName: sign)
                .resizable()
                .frame(width: 80, height: 80)
                .foregroundColor(color)
                .padding()
            
            Text(message)
            
            Spacer()
        }
    }
}

struct DestinationNotFoundView_Previews: PreviewProvider {
    static var previews: some View {
        ExceptionView(sign: "exclamationmark.circle", message: "Bài viết đã bị gỡ bỏ!")
    }
}
