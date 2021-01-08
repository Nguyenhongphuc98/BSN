//
//  BorrowResultView.swift
//  Interface
//
//  Created by Phucnh on 10/8/20.
//

import SwiftUI

struct BorrowResultView: View {
    
    @StateObject var viewModel: BorrowResultViewModel = BorrowResultViewModel()
    
    var formater: String = "EEEE, MMM d, yyyy"
    
    @Environment(\.presentationMode) var presentationMode
    
    var bbid: String
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 20) {
                Text(title)
                    .foregroundColor(titleforeground)
                    .font(.system(size: 22))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: false)
                    .padding(.vertical)
                
                BorrowBookHeader(model: viewModel.borrowBook.userbook, isRequest: false, isShowForOwner: false)
                    .padding(.horizontal, 8)
                
                VStack(alignment: .leading) {
                    TextWithIconInfo(icon: "mappin.and.ellipse", title: "Địa chỉ giao dịch", content: viewModel.borrowBook.transactionInfo.adress)
                    
                    TextWithIconInfo(icon: "clock", title: "Thời điểm mượn", content: viewModel.borrowBook.transactionInfo.exchangeDate!.getDateStr(format: formater))
                    
                    TextWithIconInfo(icon: "clock.arrow.circlepath", title: "Thời gian mượn", content: "\(viewModel.borrowBook.transactionInfo.numDay!) Ngày")
                }
                .padding(.horizontal)
                
                Text(des)
                    .roboto(size: 15)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .foregroundColor(.gray)
                    .padding()
                    .fixedSize(horizontal: false, vertical: false)
                
    //            if viewModel.borrowBook.transactionInfo.progess == .accept {
    //                Button(action: {
    //
    //                }, label: {
    //                    Text("Đi tới tin nhắn")
    //                })
    //                .buttonStyle(BaseButtonStyle(size: .large))
    //            } else {
                    
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("     Quay lại     ")
                    })
                    .buttonStyle(BaseButtonStyle(size: .large))
                //}
                
                Spacer()
            }
            .embededLoadingFull(isLoading: $viewModel.isLoading)
            .padding(.horizontal)
        }
        .navigationBarTitle("Kết quả mượn sách", displayMode: .inline)
        .navigationBarHidden(false)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
        .transition(.scale)
        .onAppear(perform: viewAppeared)
    }
    
    var backButton: some View {
        Button {
            dismiss()
        } label: {
            BackWardButton()
        }
    }
    
    var title: String {
        let success = "Chúc mừng\nBạn đã mượn thành công!"
        let fail = "Mượn thất bại!"
        return viewModel.borrowBook.transactionInfo.progess == .accept ? success : fail
    }
    
    var titleforeground: Color {
        viewModel.borrowBook.transactionInfo.progess == .accept ? ._primary : .init(hex: 0xFC6D2F)
    }
    
    var des: String {
        if viewModel.borrowBook.transactionInfo.progess == .accept {
            return "Chúng tôi đã tạo cho bạn một cuộc trò chuyện, di chuyển vào mục tin nhắn để trao đổi cụ thể hơn về việc mượn sách"
        } else {
            return "\"\(viewModel.borrowBook.transactionInfo.message)\""
        }
    }
    
    private func viewAppeared() {
        viewModel.prepareData(bbid: bbid)
    }
    
    private func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }
}

struct BorrowResultView_Previews: PreviewProvider {
    static var previews: some View {
        BorrowResultView(bbid: "")
    }
}
