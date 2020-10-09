//
//  ExchangeBookCard.swift
//  Interface
//
//  Created by Phucnh on 10/5/20.
//

import SwiftUI

struct ExchangeBookCard: View {
    
    var model: ExchangeBook
    
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
            
            Image(model.photo, bundle: interfaceBundle)
                .resizable()
                .frame(width: 110, height: 130)
                
            VStack(alignment: .leading) {
                Text(model.title)
                    .roboto(size: 15)
                
                Text(model.author)
                    .robotoLight(size: 14)
                
                Spacer()
                
                Image(systemName: "repeat")
                    .foregroundColor(._primary)
                    .padding(.horizontal)
                
                Spacer()
                
                Text(model.exchangeBookTitle)
                    .roboto(size: 15)
                
                Text(model.exchangeBookAuthor)
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

struct ExchangeBookCard_Previews: PreviewProvider {
    static var previews: some View {
        ExchangeBookCard(model: ExchangeBook())
    }
}
