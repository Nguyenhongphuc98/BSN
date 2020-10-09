//
//  NotifyCard.swift
//  Interface
//
//  Created by Phucnh on 10/1/20.
//

import SwiftUI

struct NotifyCard: View {
    
    var model: Notify
    
    @State private var action: Int? = 0
    
    @EnvironmentObject var viewModel: NotifyViewModel
    
    private var icon: String {
        
        switch model.action {
        case .comment, .breakHeart, .heart:
            return "text.bubble"
            
        case .borrowBook, .exchangeBook, .borrowFail, .borrowSuccess, .exchangeFail, .exchangeSuccess:
            return "text.book.closed"
            
        case .following:
            return "heart.circle"
        }
    }
    
    private var destinationView: AnyView {
        switch model.action {
        case .comment, .breakHeart, .heart:
            return AnyView(PostDetailView(postID: model.destinationID))
            
        case .borrowBook:
            return AnyView(ConfirmBorrowBookView())
            
        case .borrowFail, .borrowSuccess:
            return AnyView(BorrowResultView())
            
        case .exchangeBook:
            return AnyView(ConfirmExchangeBookView())
            
        case .exchangeFail, .exchangeSuccess:
            return AnyView(ConfirmExchangeBookView(resultView: true))
            
        case .following:
            return AnyView(ProfileView())
        }
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            NavigationLink(destination: destinationView, tag: 1, selection: $action) {
                EmptyView()
            }
            .frame(width: 0, height: 0)
            .opacity(0)
            
            HStack(alignment: .center) {
                CircleImage(image: model.sender.avatar, diameter: 40)
                    .padding(.leading, 15)
                    .padding(.top, 5)
                
                VStack {
                    Text(model.sender.displayname)
                        .robotoBold(size: 15)
                        .foregroundColor(.black)
                    +
                        Text(" đã \(model.action.description())")
                        .roboto(size: 13)
                    
                    Spacer()
                }
                .fixedSize(horizontal: false, vertical: false)
                .padding(.top, 15)
                
                Spacer()
                
                Image(systemName: icon)
                    .foregroundColor(model.seen ? .gray : ._primary)
                    .padding(.horizontal, 10)
            }
            
            HStack {
                Spacer()
                
                VStack {
                    Spacer()
                    
                    CountTimeText(date: model.createDate)
                        .padding(.horizontal, 10)
                }
            }
        }
        .onTapGesture {
            action = 1
            viewModel.notifyDidReaded(notify: model)
        }
    }
}

struct NotifyCard_Previews: PreviewProvider {
    static var previews: some View {
        NotifyCard(model: Notify())
    }
}
