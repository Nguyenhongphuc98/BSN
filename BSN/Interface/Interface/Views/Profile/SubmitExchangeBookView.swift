//
//  CreateExchangeBookView.swift
//  Interface
//
//  Created by Phucnh on 10/11/20.
//

import SwiftUI

struct SubmitExchangeBookView: View {
    
    @StateObject private var viewModel = CreateExchangeBookViewModel()
    
    @EnvironmentObject var navState: NavigationState
    
    var body: some View {
        VStack(spacing: 30) {
            bookInfo(isMyBook: true)
            
            Image(systemName: "repeat")
                .foregroundColor(._primary)
                .padding(.horizontal)
                .font(.system(size: 28))
            
            bookInfo(isMyBook: false)
            
            Spacer()
            Button(action: {
//                viewModel.addExchangeBook { (success) in
//                    print("did create exchange book")
//                }
                
                self.navState.popTo(viewName: .profileRoot)
            }, label: {
                Text("   Hoàn tất   ")
            })
            .buttonStyle(BaseButtonStyle(size: .largeH))
            Spacer()
        }
        .padding()
    }
    
    func bookInfo(isMyBook: Bool) -> some View {
        VStack(alignment: .leading) {
            Text(getSubtitle(isMyBook: isMyBook))
                .robotoBold(size: 20)
            
            HStack(spacing: 20) {
                Image(getBookCover(isMyBook: isMyBook), bundle: interfaceBundle)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 100)
                    .background(Color.white)
                    .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.gray))
               
                VStack(alignment: .leading, spacing: 4) {
                    Spacer()
                    
                    Text(getBookName(isMyBook: isMyBook))
                        .roboto(size: 15)
                    
                    Text(getBookAuthor(isMyBook: isMyBook))
                        .robotoLight(size: 14)
                    
                    if isMyBook {
                        BookStatusText(status: getBookStatus(isMyBook: isMyBook))
                    }
                }
                Spacer()
            }
        }
        .frame(height: 120)
    }
    
    func getSubtitle(isMyBook: Bool) -> String {
        isMyBook ? "Sách của bạn" : "Sách muốn đổi"
    }
    
    func getBookName(isMyBook: Bool) -> String {
        isMyBook ? viewModel.exchangeBook.needChangeBook.title : viewModel.exchangeBook.needChangeBook.title
    }
    
    func getBookCover(isMyBook: Bool) -> String {
        isMyBook ? viewModel.exchangeBook.needChangeBook.cover! : viewModel.exchangeBook.needChangeBook.cover!
    }
    
    func getBookAuthor(isMyBook: Bool) -> String {
        isMyBook ? viewModel.exchangeBook.needChangeBook.author : viewModel.exchangeBook.needChangeBook.author
    }
    
    func getBookStatus(isMyBook: Bool) -> BookStatus {
        isMyBook ? viewModel.exchangeBook.needChangeBook.status : viewModel.exchangeBook.needChangeBook.status
    }
}

struct CreateExchangeBookView_Previews: PreviewProvider {
    static var previews: some View {
        SubmitExchangeBookView()
    }
}
