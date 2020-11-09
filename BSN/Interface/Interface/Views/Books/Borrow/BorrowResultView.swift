//
//  BorrowResultView.swift
//  Interface
//
//  Created by Phucnh on 10/8/20.
//

import SwiftUI

struct BorrowResultView: View {
    
    var viewModel: BorrowResultViewModel = BorrowResultViewModel()
    
    var formater: String = "EEEE, MMM d, yyyy"
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .center) {
                Text(title)
                    .foregroundColor(titleforeground)
                    .font(.system(size: 22))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: false)
                    .padding(.vertical)
                
                BorrowBookHeader(model: viewModel.borrowBook.userbook)
                    .padding(.horizontal, 8)
                
                VStack(alignment: .leading) {
                    TextWithIconInfo(icon: "mappin.and.ellipse", title: "Địa chỉ giao dịch", content: viewModel.borrowBook.transactionInfo.adress)
                    
                    TextWithIconInfo(icon: "clock", title: "Thời điểm mượn", content: viewModel.borrowBook.transactionInfo.exchangeDate!.getDateStr(format: formater))
                    
                    TextWithIconInfo(icon: "clock.arrow.circlepath", title: "Thời gian mượn", content: "\(viewModel.borrowBook.transactionInfo.numDay!) Ngày")
                }
                .padding()
                
                Spacer()
                
                Text(des)
                    .roboto(size: 15)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
                    .padding()
                    .fixedSize(horizontal: false, vertical: false)
                
                if viewModel.borrowBook.transactionInfo.progess == .accept {
                    Button(action: {
                        
                    }, label: {
                        Text("Đi tới tin nhắn")
                    })
                    .buttonStyle(BaseButtonStyle(size: .large))
                } else {
                    
                    Button(action: {
                        AppManager.shared.selectedIndex = 2
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Về trang chủ")
                    })
                    .buttonStyle(BaseButtonStyle(size: .large))
                }
                
                Spacer()
            }
        }
        .padding(.horizontal)
        .navigationBarTitle("Kết quả mượn sách", displayMode: .inline)
        .navigationBarHidden(false)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
    }
    
    var backButton: some View {
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            Image(systemName: "chevron.backward")
                .foregroundColor(.gray)
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
            return "Chúng tôi đã tạo cho bạn một cuộc trò chuyện, nhấn vào “đi tới tin nhắn” để trao đổi cụ thể hơn về việc mượn sách"
        } else {
            return "\"\(viewModel.borrowBook.transactionInfo.message)\""
        }
    }
}

struct BorrowResultView_Previews: PreviewProvider {
    static var previews: some View {
        BorrowResultView()
    }
}
