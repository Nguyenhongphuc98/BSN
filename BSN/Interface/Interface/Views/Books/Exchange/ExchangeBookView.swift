//
//  ExchangeBookJustVView.swift
//  Interface
//
//  Created by Phucnh on 10/9/20.
//

import SwiftUI

struct ExchangeBookView: View {
    
    @StateObject var viewModel: ExchangeBookViewModel = ExchangeBookViewModel()
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            BorrowBookHeader(model: viewModel.exchangeBook, showSeperator: false)
            
            Image(systemName: "repeat")
                .foregroundColor(._primary)
                .padding(.horizontal)
                .font(.system(size: 28))
            
            ExchangeBookSecondHeader(model: viewModel.exchangeBook, isCanChange: viewModel.canExchange)
            
            if viewModel.canExchange {
                InputWithTitle(content: $viewModel.traddingAdress, placeHolder: "Địa chỉ thuận tiện nhất cho giao dịch", title: "Địa chỉ giao dịch")
                
                InputWithTitle(content: $viewModel.message, placeHolder: "ex: Bạn ơi cho mình đổi cuốn này nhé!", title: "Lời nhắn")
                
                Button(action: {
                    dismiss()
                }, label: {
                    Text("Hoàn tất")
                })
                .buttonStyle(BaseButtonStyle(size: .large))
                
            } else {
                Spacer()
                
                Button(action: {
                    dismiss()
                }, label: {
                    Text("Quay lại")
                })
                .buttonStyle(BaseButtonStyle(size: .large))
            }
            Spacer()
        }
        .padding(.horizontal)
        .background(Color(.secondarySystemBackground))
        .navigationBarTitle("Hoàn đổi mượn sách", displayMode: .inline)
        .navigationBarHidden(false)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
    }
    
    var backButton: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "chevron.backward")
                .foregroundColor(.gray)
        }
    }
    
    func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }
}

struct ExchangeBookJustVView_Previews: PreviewProvider {
    static var previews: some View {
        ExchangeBookView()
    }
}

struct ExchangeBookSecondHeader: View {
    
    var model: BorrowBookDetail
    
    var isCanChange: Bool = true
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                VStack(alignment: .leading, spacing: 4) {
                    Spacer()
                    
                    Text(model.book.name)
                        .roboto(size: 15)
                    
                    Text(model.book.author)
                        .robotoLight(size: 14)
                    
                    if isCanChange {
                        BookStatusText(status: model.status)
                    } else {
                        Text("Bạn không có cuốn sách này")
                            .robotoBold(size: 14)
                            .foregroundColor(.init(hex: 0xFF6D1B))
                    }
                }
                
                Image(model.book.photo, bundle: interfaceBundle)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 100)
                    .background(Color.white)
                    .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.gray))
            }
            
            if isCanChange {
                Text(model.statusDes)
                    .roboto(size: 13)
                    .padding(.vertical)
                    .foregroundColor(.black)
            }
        }
        .frame(height: height)
    }
    
    var height: CGFloat {
        isCanChange ? 155 : 100
    }
}

//struct ExchangeBookSecondHeader_Previews: PreviewProvider {
//    static var previews: some View {
//        ExchangeBookSecondHeader(model: BorrowBookDetail(), isCanChange: true)
//    }
//}
