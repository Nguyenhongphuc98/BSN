//
//  ExchangeBookCell.swift
//  Interface
//
//  Created by Phucnh on 10/9/20.
//

import SwiftUI

// Using in list available book-user can exchange
struct ExchangeBookCell: View {
    
    var model: ExchangeBook4C
    
    @State private var nav: Bool = false
    
    var body: some View {
        HStack {
            NavigationLink(
                destination: ExchangeBookView(),
                isActive: $nav,
                label: {
                    EmptyView()
                })
                .frame(width: 0, height: 0)
            
            CircleImage(image: model.owner.avatar, diameter: 60)
            
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Image(systemName: "text.book.closed")
                    
                    Text(model.exchangeBookName)
                        .roboto(size: 18)
                }
                
                Text(model.owner.displayname)
                    .roboto(size: 18)
                
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        DistanceText(distance: model.distance)
                        BookStatusText(status: model.status)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        nav.toggle()
                    }, label: {
                        Text("Trao đổi")
                    })
                    .buttonStyle(BaseButtonStyle())
                }
            }
        }
        .padding(.vertical, 5)
    }
}

struct ExchangeBookCell_Previews: PreviewProvider {
    static var previews: some View {
        ExchangeBookCell(model: ExchangeBook4C())
    }
}
