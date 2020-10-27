//
//  MyBookCard.swift
//  Interface
//
//  Created by Phucnh on 10/27/20.
//

import SwiftUI

struct SuggestBookCard: View {
    
    var model: BSusggestBook
    
    var navToMyBook: Bool = false
    
    var body: some View {
        NavigationLink(
            destination: navigateView,
            label: {
                VStack(alignment: .center) {
                    Image(model.cover!, bundle: interfaceBundle)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 120)
                        
                    VStack(alignment: .leading) {
                        Text(model.title)
                            .roboto(size: 15)
                        
                        Text(model.author)
                            .robotoLight(size: 14)
                        
                        HStack {
                            StarRating(rating: model.avgRating)
                            
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
                .foregroundColor(.black)
                .padding(.horizontal, 5)
                .padding(.top, 5)
            })
    }
    
    var navigateView: AnyView {
        navToMyBook ? .init(MyBookDetailView()) : .init(BookDetailView())
    }
}

struct MyBookCard_Previews: PreviewProvider {
    static var previews: some View {
        SuggestBookCard(model: BSusggestBook())
    }
}
