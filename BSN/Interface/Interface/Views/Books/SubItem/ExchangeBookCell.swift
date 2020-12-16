//
//  ExchangeBookCell.swift
//  Interface
//
//  Created by Phucnh on 10/9/20.
//

import SwiftUI

// Using in list available book-user can exchange
struct ExchangeBookCell: View {
    
    var model: BAvailableExchange
    
    @State private var nav: Bool = false
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        HStack {
            CircleImage(image: model.createrPhoto, diameter: 60)
            
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Image(systemName: "text.book.closed")
                    
                    Text(model.exchangeBookName)
                        .roboto(size: 16)
                        .lineLimit(1)
                }
                
                Text(model.createrName)
                    .roboto(size: 16)
                    .lineLimit(1)
                
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        DistanceText(distance: model.distance)
                        BookStatusText(status: model.status)
                    }
                    
                    Spacer()
                    
                    NavigationLink(
                        destination: ExchangeBookView(ebID: model.id!) {
                            presentationMode.wrappedValue.dismiss()
                        },
                        isActive: $nav,
                        label: {
                            Text("Trao đổi")
                        })
                        .buttonStyle(BaseButtonStyle())                    
                }
            }
        }
        .padding(10)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .padding(.horizontal, 10)
    }
}

struct ExchangeBookCell_Previews: PreviewProvider {
    static var previews: some View {
        ExchangeBookCell(model: BAvailableExchange())
    }
}
