//
//  SearchBookCard.swift
//  Interface
//
//  Created by Phucnh on 10/5/20.
//

import SwiftUI

struct SearchBookCard: View {
    
    var model: Book
    
    var body: some View {
//        NavigationLink(
//            destination: BookDetailView(),
//            label: {
//
//            })
        
        HStack(alignment: .center) {
            //Image(model.photo, bundle: interfaceBundle)
            BSNImage(urlString: model.photo, tempImage: "book_cover")
                .frame(width: 50, height: 60)
            
            VStack(alignment: .leading) {
                Spacer()
                
                Text(model.name)
                    .roboto(size: 15)
                
                Text(model.author)
                    .robotoLight(size: 14)
            }
            .padding(.bottom, 5)
            
            Spacer()
        }
        .foregroundColor(.black)
        .frame(height: 60)
        .padding(7)
    }
}

struct SearchBookCard_Previews: PreviewProvider {
    static var previews: some View {
        SearchBookCard(model: Book())
    }
}
