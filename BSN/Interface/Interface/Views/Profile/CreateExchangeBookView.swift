//
//  CreateExchangeBookView.swift
//  Interface
//
//  Created by Phucnh on 10/11/20.
//

import SwiftUI

struct CreateExchangeBookView: View {
    
    @StateObject private var viewModel = CreateExchangeBookViewModel()
    
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
                viewModel.addExchangeBook { (success) in
                    print("did create exchange book")
                }
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
            Text(isMyBook ? "Sách của bạn" : "Sách muốn đổi")
                .robotoBold(size: 20)
            
            HStack(spacing: 20) {
                Image(viewModel.exchangeBook.book.photo, bundle: interfaceBundle)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 100)
                    .background(Color.white)
                    .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.gray))
               
                VStack(alignment: .leading, spacing: 4) {
                    Spacer()
                    
                    Text(viewModel.exchangeBook.book.name)
                        .roboto(size: 15)
                    
                    Text(viewModel.exchangeBook.book.author)
                        .robotoLight(size: 14)
                    
                    if isMyBook {
                        BookStatusText(status: viewModel.exchangeBook.status)
                    }
                }
                Spacer()
            }
        }
        .frame(height: 120)
    }
}

struct CreateExchangeBookView_Previews: PreviewProvider {
    static var previews: some View {
        CreateExchangeBookView()
    }
}
