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
    
    @StateObject var viewModel: ConfirmExchangebookViewModel = ConfirmExchangebookViewModel()
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showDeclineView: Bool = false
    
    var resultView: Bool = false
    
    var ebid: String
    
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
                
                BorrowBookHeader(model: viewModel.exchangeBook.needChangeBook, isRequest: false, isShowForOwner: true)
                
                Image(systemName: "repeat")
                    .foregroundColor(._primary)
                    .padding(.horizontal)
                    .font(.system(size: 28))
                
                ExchangeBookSecondHeader(model: viewModel.exchangeBook.wantChangeBook!, isRequest: false)
                    .padding(.bottom)
                
                TextWithIconInfo(icon: "clock", title: "Địa chỉ giao dịch", content: viewModel.exchangeBook.transactionInfo.adress)
                
                TextWithIconInfo(icon: "clock.arrow.circlepath", title: "Lời nhắn", content: viewModel.exchangeBook.transactionInfo.message)
               
                Spacer(minLength: 30)
                
                if !resultView {
                    if viewModel.exchangeBook.transactionInfo.progess == .waiting {
                        confirmAction
                    } else {
                        Text("Yêu cầu đã được \(viewModel.exchangeBook.transactionInfo.progess.des())")
                            .robotoLight(size: 15)
                    }
                } else {
                    resultAction
                }
                
                Spacer()
            }
            .padding()
            .navigationBarTitle(navTitle, displayMode: .inline)
            .navigationBarHidden(false)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: backButton)
            .sheet(isPresented: $showDeclineView, content: {
                DeclineEoBBookView(isBorrow: false, targetID: viewModel.exchangeBook.id!) {
                    dismiss()
                }
            })
        }
        .embededLoadingFull(isLoading: $viewModel.isLoading)
        .onAppear(perform: viewAppeared)
    }
    
    var backButton: some View {
        Button {
            dismiss()
        } label: {
            BackWardButton()
        }
    }
    
    var navTitle: String {
        resultView ? "Kết quả đổi sách" : "Lời mời đổi sách"
    }
    
    var title: String {
        let success = "Chúc mừng\nBạn đã đổi sách thành công!"
        let fail = "Đổi sách thất bại!"
        return viewModel.exchangeBook.transactionInfo.progess == .accept ? success : fail
    }
    
    var titleforeground: Color {
        viewModel.exchangeBook.transactionInfo.progess == .accept ? ._primary : .init(hex: 0xFC6D2F)
    }
    
    var des: String {
        if viewModel.exchangeBook.transactionInfo.progess == .accept {
            return "Chúng tôi đã tạo cho bạn một cuộc trò chuyện, nhấn vào “đi tới tin nhắn” để trao đổi cụ thể hơn về việc đổi sách"
        } else {
            return "\"\(viewModel.exchangeBook.transactionInfo.message)\""
        }
    }
    
    var confirmAction: some View {
        HStack(spacing: 30) {
            Button(action: {
                self.showDeclineView = true
            }, label: {
                Text("   Từ chối   ")
            })
            .buttonStyle(BaseButtonStyle(size: .large,type: .secondary))
            
            Button(action: {
                viewModel.didAccept()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    dismiss()
                }
            }, label: {
                Text("   Đồng ý   ")
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
            
            if viewModel.exchangeBook.transactionInfo.progess == .accept {
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
                    Text("    Quay lại    ")
                })
                .buttonStyle(BaseButtonStyle(size: .large))
            }
        }
    }
    
    func viewAppeared() {
        viewModel.prepareData(ebID: ebid)
    }
    
    func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }
}

struct ConfirmExchangeBookView_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmExchangeBookView(ebid: "")
    }
}
