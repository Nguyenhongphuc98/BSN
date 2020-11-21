//
//  BorowBookCard.swift
//  Interface
//
//  Created by Phucnh on 10/6/20.
//

import SwiftUI

// Using in list available book-user can borrow
struct BorrowBookCell: View, PopToable {
    
    var viewName: ViewName = .bookDetail
    
    var model: BAvailableTransaction
    
    @State private var nav: Bool = false
    
    @EnvironmentObject var navState: NavigationState
    
    var body: some View {
        HStack {
            NavigationLink(
                destination: SubmitRequestBorrowView(ubid: model.userBookID!).environmentObject(navState),
                isActive: $nav,
                label: {
                    EmptyView()
                })
                .frame(width: 0, height: 0)
            
            CircleImage(image: model.createrPhoto, diameter: 50)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(model.createrName)
                    .roboto(size: 18)
                    .lineLimit(1)
                
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
        .onReceive(navState.$viewName) { (viewName) in
            if viewName == self.viewName {
                nav = false
            }
        }
    }
}

struct BorowBookCard_Previews: PreviewProvider {
    static var previews: some View {
        BorrowBookCell(model: BAvailableTransaction())
    }
}
