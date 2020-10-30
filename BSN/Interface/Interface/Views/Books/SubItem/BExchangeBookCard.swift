//
//  BExchangeBookCard.swift
//  Interface
//
//  Created by Phucnh on 10/27/20.
//

import SwiftUI

struct BExchangeBookCard: View {
    
    var model: BExchangeBook
    
    @State private var nav: Bool = false
    
    var body: some View {
        HStack(alignment: .center) {
            NavigationLink(
                destination: ExchangeBookView(),
                isActive: $nav,
                label: {
                    EmptyView()
                })
                .frame(width: 0, height: 0)
                .opacity(0)
            
            Image(model.needChangeBook.cover!, bundle: interfaceBundle)
                .resizable()
                .frame(width: 110, height: 130)
                
            VStack(alignment: .leading) {
                Text(model.needChangeBook.title)
                    .roboto(size: 15)
                
                Text(model.needChangeBook.author)
                    .robotoLight(size: 14)
                
                Spacer()
                
                HStack {
                    Image(systemName: "repeat")
                        .foregroundColor(._primary)
                        .padding(.horizontal)
                    
                    DistanceText(distance: model.distance, style: .short)
                }
                
                Spacer()
                
                Text(model.wantChangeBook!.title)
                    .roboto(size: 15)
                
                Text(model.wantChangeBook!.author)
                    .robotoLight(size: 14)
                
            }
            
            Spacer()
        }
        .padding()
        .background(Color.init(hex: 0xF9F9F9))
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.25), radius: 4, x: 2, y: 2)
        .padding(.horizontal)
    }
}

struct BExchangeBookCard_Previews: PreviewProvider {
    static var previews: some View {
        BExchangeBookCard(model: BExchangeBook())
    }
}