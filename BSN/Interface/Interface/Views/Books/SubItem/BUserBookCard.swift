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
    
    @State private var ubid: String = ""
    
    var body: some View {
        VStack {
            NavigationLink(
                destination:navigateView,
                isActive: $activeBookDetail,
                label: {
                    BBookCard(model: model) {
                        BookStatusText(status: model.status!)
                    }
                    
                })
            
            footer
        }
        .onReceive(navState.$viewName) { (viewName) in
            if viewName == self.viewName {
                activeBookDetail = false
                activeSearchBook = false
            }
        }
    }
    
    var navigateView: AnyView {
        //isGuest ? .init(BookDetailView(bookID: model.bookID).environmentObject(navState)) : .init(MyBookDetailView(ubid: model.id!))
        isGuest ? .init(GuestBookDetailView(ubid: model.id!).environmentObject(navState)) : .init(MyBookDetailView(ubid: model.id!))
    }
    
    var footer: some View {
        Group {
            if AppManager.shared.currenUID != model.ownerID {
//            if isGuest {
//                Button(action: {
//                    print("did click borrow book")
//                }, label: {
//                    Text("Mượn sách")
//                })
//                .buttonStyle(BaseButtonStyle(size: .mediumH))
            } else {
//                Button(action: {
//                    print("did click exchange book")
//                    navState.viewName = .undefine
//                    activeSearchBook.toggle()
//                }, label: {
                    
                    NavigationLink(
                        destination: SearchAddBookView(useForExchangeBook: true)
                            .environmentObject(navState)
                            .environmentObject(PassthroughtEB(userBook: model)),
                        isActive: $activeSearchBook,
                        label: {
                            Text(" Đổi sách  ")
                        })
               // })
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
