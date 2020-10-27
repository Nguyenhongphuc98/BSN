//
//  MyBookCard.swift
//  Interface
//
//  Created by Phucnh on 10/27/20.
//

import SwiftUI

struct SuggestBookCard: View {
    
    var model: BSusggestBook
    
    var body: some View {
        NavigationLink(
            destination: BookDetailView(),
            label: {
                BBookCard(model: model) {
                    HStack {
                        StarRating(rating: model.avgRating)
                        
                        Text("\(model.numReview) nhận xét")
                            .roboto(size: 12)
                        
                        Spacer()
                    }
                }
            })
    }
}

struct MyBookCard_Previews: PreviewProvider {
    static var previews: some View {
        SuggestBookCard(model: BSusggestBook())
    }
}
