//
//  MyBookCard.swift
//  Interface
//
//  Created by Phucnh on 10/27/20.
//

import SwiftUI

struct SuggestBookCard: View {
    
    @StateObject var model: BSusggestBook
    
    @EnvironmentObject var navState: NavigationState
    
    var body: some View {
        NavigationLink(
            destination: BookDetailView(bookID: model.id!).environmentObject(navState),
            label: {
                BBookCard(model: model) {
                    HStack {
                        StarRating(rating: model.avgRating)
                        
                        Text("\(model.numReview) nhận xét")
                            .roboto(size: 12)
                        
                        Spacer()
                    }
                }
                .id(UUID())
            })
    }
}

struct MyBookCard_Previews: PreviewProvider {
    static var previews: some View {
        SuggestBookCard(model: BSusggestBook())
    }
}
