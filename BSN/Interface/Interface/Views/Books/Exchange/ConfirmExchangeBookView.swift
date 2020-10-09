//
//  ConfirmExchangeBookView.swift
//  Interface
//
//  Created by Phucnh on 10/9/20.
//

import SwiftUI

// View showing when recevice resuqts exchange book
// And when receive notify exchange result
struct ConfirmExchangeBookView: View {
    
    @StateObject var viewModel: ExchangeBookViewModel = ExchangeBookViewModel()
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showDeclineView: Bool = false
    
    var resultView: Bool = false
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                // when fail or success exchange book
                if resultView {
                    Text(title)
                        .foregroundColor(titleforeground)
                        .font(.system(size: 22))
                        .multilineTextAlignment(.center)
                }
                
                BorrowBookHeader(model: viewModel.exchangeBook, showSeperator: false)
                
                Image(systemName: "repeat")
                    .foregroundColor(._primary)
                    .padding(.horizontal)
                    .font(.system(size: 28))
                
                ExchangeBookSecondHeader(model: viewModel.exchangeBook, isCanChange: viewModel.canExchange)
                
                TextWithIconInfo(icon: "clock", title: "Địa chỉ giao dịch", content: viewModel.exchangeBook.traddingAddress)
                
                TextWithIconInfo(icon: "clock.arrow.circlepath", title: "Lời nhắn", content: viewModel.exchangeBook.message)
               
                if !resultView {
                    if viewModel.exchangeBook.result == .unknown {
                        confirmAction
                    }
                } else {
                    resultAction
                }
                
                Spacer()
            }
            .padding(.horizontal)
            .background(Color(.secondarySystemBackground))
            .navigationBarTitle(navTitle, displayMode: .inline)
            .navigationBarHidden(false)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: backButton)
            .sheet(isPresented: $showDeclineView, content: {
                DeclineEoBBookView(isBorrow: false)
            })
        }
    }
    
    var backButton: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "chevron.backward")
                .foregroundColor(.gray)
        }
    }
    
    var navTitle: String {
        resultView ? "Kết quả đổi sách" : "Lời mời đổi sách"
    }
    
    var title: String {
        let success = "Chúc mừng\nBạn đã đổi sách thành công!"
        let fail = "Đổi sách thất bại!"
        return viewModel.exchangeBook.result == .success ? success : fail
    }
    
    var titleforeground: Color {
        viewModel.exchangeBook.result == .success ? ._primary : .init(hex: 0xFC6D2F)
    }
    
    var des: String {
        if viewModel.exchangeBook.result == .success {
            return "Chúng tôi đã tạo cho bạn một cuộc trò chuyện, nhấn vào “đi tới tin nhắn” để trao đổi cụ thể hơn về việc đổi sách"
        } else {
            return "\"\(viewModel.exchangeBook.reason)\""
        }
    }
    
    var confirmAction: some View {
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
    
    var resultAction: some View {
        VStack {
            Text(des)
                .roboto(size: 15)
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
                .padding()
                .fixedSize(horizontal: false, vertical: false)
            
            if viewModel.exchangeBook.result == .success {
                Button(action: {
                    dismiss()
                }, label: {
                    Text("Đi tới tin nhắn")
                })
                .buttonStyle(BaseButtonStyle(size: .large))
            } else {
                Button(action: {
                    dismiss()
                }, label: {
                    Text("Về trang chủ")
                })
                .buttonStyle(BaseButtonStyle(size: .large))
            }
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
