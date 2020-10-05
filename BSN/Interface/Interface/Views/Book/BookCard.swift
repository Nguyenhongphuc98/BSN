//
//  BookCard.swift
//  Interface
//
//  Created by Phucnh on 10/5/20.
//

import SwiftUI

struct BookCard: View {
    
    var model: Book
    
    var body: some View {
        VStack(alignment: .center) {
            Image(model.photo, bundle: interfaceBundle)
                .resizable()
                .frame(width: 100, height: 120)
                
            VStack(alignment: .leading) {
                Text(model.name)
                    .roboto(size: 15)
                
                Text(model.author)
                    .robotoLight(size: 14)
                
                HStack {
                    StarRating(rating: model.rating)
                    
                    Text("\(model.numReview) nhận xét")
                        .roboto(size: 12)
                    
                    Spacer()
                }
            }
        }
        .padding(5)
        .background(Color.init(hex: 0xF9F9F9))
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.25), radius: 4, x: 2, y: 2)
    }
}

struct BookCard_Previews: PreviewProvider {
    static var previews: some View {
        BookCard(model: Book())
    }
}
