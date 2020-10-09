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
        VStack(alignment: .center) {
            Text(title)
                .foregroundColor(titleforeground)
                .font(.system(size: 22))
                .multilineTextAlignment(.center)
            
            BorrowBookHeader(model: viewModel.borrowBook, isResultView: true)
                .padding(.horizontal)
            
            VStack(alignment: .leading) {
                TextWithIconInfo(icon: "mappin.and.ellipse", title: "Địa chỉ giao dịch", content: viewModel.borrowBook.traddingAddress)
                
                TextWithIconInfo(icon: "clock", title: "Thời điểm mượn", content: viewModel.borrowBook.borrowDate.getDate(format: formater))
                
                TextWithIconInfo(icon: "clock.arrow.circlepath", title: "Thời gian mượn", content: "\(viewModel.borrowBook.numOfDay) Ngày")
            }
            .padding()
            
            Spacer()
            
            Text(des)
                .roboto(size: 15)
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
                .padding()
            
            Button(action: {
                AppManager.shared.selectedIndex = 2
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Text(viewModel.borrowBook.result == .success ? "Đi tới tin nhắn" : "Về trang chủ")
            })
            .buttonStyle(BaseButtonStyle(size: .large))
            
            Spacer()
        }
        .padding()
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
        let success = "Chúc mừng\nbạn đã mượn thành công!"
        let fail = "Mượn thất bại!"
        return viewModel.borrowBook.result == .success ? success : fail
    }
    
    var titleforeground: Color {
        viewModel.borrowBook.result == .success ? ._primary : .init(hex: 0xFC6D2F)
    }
    
    var des: String {
        if viewModel.borrowBook.result == .success {
            return "Chúng tôi đã tạo cho bạn một cuộc trò chuyện, nhấn vào “đi tới tin nhắn” để trao đổi cụ thể hơn về việc mượn sách"
        } else {
            return "\"\(viewModel.borrowBook.reason)\""
        }
    }
}

struct BorrowResultView_Previews: PreviewProvider {
    static var previews: some View {
        BorrowResultView()
    }
}
