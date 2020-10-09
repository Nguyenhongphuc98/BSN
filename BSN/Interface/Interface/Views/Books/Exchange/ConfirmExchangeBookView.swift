//
//  ConfirmExchangeBookView.swift
//  Interface
//
//  Created by Phucnh on 10/9/20.
//

import SwiftUI

// View showing when recevice resuqts exchange book
struct ConfirmExchangeBookView: View {
    
    @StateObject var viewModel: ExchangeBookViewModel = ExchangeBookViewModel()
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showDeclineView: Bool = false
    
    var body: some View {
        VStack {
            BorrowBookHeader(model: viewModel.exchangeBook, showSeperator: false)
            
            Image(systemName: "repeat")
                .foregroundColor(._primary)
                .padding(.horizontal)
                .font(.system(size: 28))
            
            ExchangeBookSecondHeader(model: viewModel.exchangeBook, isCanChange: viewModel.canExchange)
            
            TextWithIconInfo(icon: "clock", title: "Địa chỉ giao dịch", content: viewModel.exchangeBook.traddingAddress)
            
            TextWithIconInfo(icon: "clock.arrow.circlepath", title: "Lời nhắn", content: viewModel.exchangeBook.message)
           
            if viewModel.exchangeBook.result == .unknown {
                HStack(spacing: 30) {
                    Button(action: {
                        dismiss()
                    }, label: {
                        Text("Từ chối")
                    })
                    .buttonStyle(BaseButtonStyle(size: .large,type: .secondary))
                    
                    Button(action: {
                        dismiss()
                    }, label: {
                        Text("Đồng ý")
                    })
                    .buttonStyle(BaseButtonStyle(size: .large))
                }
            }
            
            Spacer()
        }
        .padding(.horizontal)
        .background(Color(.secondarySystemBackground))
        .navigationBarTitle("Lời mời đổi sách", displayMode: .inline)
        .navigationBarHidden(false)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
        .sheet(isPresented: $showDeclineView, content: {
            DeclineEoBBookView(isBorrow: false)
        })
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

struct ConfirmExchangeBookView_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmExchangeBookView()
    }
}
