//
//  BorowBookCard.swift
//  Interface
//
//  Created by Phucnh on 10/6/20.
//

import SwiftUI

// Using in list available book-user can borrow
struct BorrowBookCell: View {
    
    var model: BAvailableTransaction
    
    @State private var nav: Bool = false
    
    var body: some View {
        HStack {
            NavigationLink(
                destination: SubmitRequestBorrowView(),
                isActive: $nav,
                label: {
                    EmptyView()
                })
                .frame(width: 0, height: 0)
            
            CircleImage(image: model.createrPhoto, diameter: 50)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(model.createrName)
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
                        Text("Mượn")
                    })
                    .buttonStyle(BaseButtonStyle())
                }
            }
        }
        .padding(.vertical, 5)
    }
}

struct BorowBookCard_Previews: PreviewProvider {
    static var previews: some View {
        BorrowBookCell(model: BAvailableTransaction())
    }
}
