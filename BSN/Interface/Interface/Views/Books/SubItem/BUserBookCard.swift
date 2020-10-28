//
//  BUserBookCard.swift
//  Interface
//
//  Created by Phucnh on 10/27/20.
//

import SwiftUI

struct BUserBookCard: View {
    
    var model: BUserBook
    
    var isGuest: Bool = false
    
    var body: some View {
        NavigationLink(
            destination:navigateView,
            label: {
                VStack {
                    BBookCard(model: model) {
                        BookStatusText(status: model.status)
                    }
                    
                    footer
                }
            })
    }
    
    var navigateView: AnyView {
        isGuest ? .init(BookDetailView()) : .init(MyBookDetailView())
    }
    
    var footer: some View {
        Group {
            if isGuest {
                Button(action: {
                    print("did click borrow book")
                }, label: {
                    Text("Mượn sách")
                })
                .buttonStyle(BaseButtonStyle(size: .mediumH))
            } else {
                Button(action: {
                    print("did click exchange book")
                }, label: {
                    NavigationLink(
                        destination: SearchAddBookView(justSearchInStore: true),
                        label: {
                            Text(" Đổi sách  ")
                        })
                })
                .buttonStyle(BaseButtonStyle(size: .mediumH))
            }
        }
    }
}

struct BUserBookCard_Previews: PreviewProvider {
    static var previews: some View {
        BUserBookCard(model: BUserBook())
    }
}
