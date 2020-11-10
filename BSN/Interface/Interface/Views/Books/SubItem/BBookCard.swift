//
//  BBookCard.swift
//  Interface
//
//  Created by Phucnh on 10/27/20.
//

import SwiftUI

// Book card template
// Using show core info of book
// Ex: suggest book, my book can using it
struct BBookCard<Content: View>: View {
    
    var model: BBook
    
    // Addition content
    var content: Content
    
    init(model: BBook, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.model = model
    }
    
    var body: some View {
        VStack(alignment: .center) {
            BSNImage(urlString: model.cover!, tempImage: "book_cover")
                .frame(width: 100, height: 140)
            
            VStack(alignment: .leading) {
                Text(model.title)
                    .roboto(size: 15)
                    .lineLimit(1)
                
                Text(model.author)
                    .robotoLight(size: 14)
                    .lineLimit(1)
                
                content
                
                HStack {
                    Spacer()
                }
            }
        }
        .padding(5)
        .background(Color.init(hex: 0xF9F9F9))
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.25), radius: 4, x: 2, y: 2)
        .foregroundColor(.black)
        .padding(.horizontal, 5)
        .padding(.top, 5)
    }
}

struct BBookCard_Previews: PreviewProvider {
    static var previews: some View {
        BBookCard(model: BBook()) {
            Text("test")
        }
    }
}
