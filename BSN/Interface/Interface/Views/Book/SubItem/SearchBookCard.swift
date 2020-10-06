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
        NavigationLink(
            destination: BookDetailView(),
            label: {
                HStack(alignment: .center) {
                    Image(model.photo, bundle: interfaceBundle)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 60)
                    
                    VStack(alignment: .leading) {
                        Spacer()
                        
                        Text(model.name)
                            .roboto(size: 15)
                        
                        Text(model.author)
                            .robotoLight(size: 14)
                    }
                    
                    Spacer()
                }
                .foregroundColor(.black)
            })
    }
}

struct SearchBookCard_Previews: PreviewProvider {
    static var previews: some View {
        SearchBookCard(model: Book())
    }
}
