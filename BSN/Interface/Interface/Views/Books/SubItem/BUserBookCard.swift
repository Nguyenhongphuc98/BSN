//
//  BUserBookCard.swift
//  Interface
//
//  Created by Phucnh on 10/27/20.
//

import SwiftUI

struct BUserBookCard: View, PopToable {
    
    var viewName: ViewName = .profileRoot
    
    var model: BUserBook
    
    var isGuest: Bool = false
    
    @EnvironmentObject var navState: NavigationState
    
    @State private var activeBookDetail: Bool = false
    
    @State private var activeSearchBook: Bool = false
    
    var body: some View {
        NavigationLink(
            destination:navigateView,
            isActive: $activeBookDetail,
            label: {
                VStack {
                    BBookCard(model: model) {
                        BookStatusText(status: model.status)
                    }
                    
                    footer
                }
            })
            .onReceive(navState.$viewName) { (viewName) in
                if viewName == self.viewName {
                    activeBookDetail = false
                    activeSearchBook = false
                }
            }
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
                    activeSearchBook.toggle()
                }, label: {
                    NavigationLink(
                        destination: SearchAddBookView(useForExchangeBook: true).environmentObject(navState),
                        isActive: $activeSearchBook,
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
