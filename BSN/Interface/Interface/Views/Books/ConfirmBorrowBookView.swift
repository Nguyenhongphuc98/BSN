//
//  ConfirmBorrowBookView.swift
//  Interface
//
//  Created by Phucnh on 10/8/20.
//

import SwiftUI

struct ConfirmBorrowBookView: View {
    
    var viewModel: ConfirmBorrowBookViewModel = ConfirmBorrowBookViewModel()
    
    var formater: String = "EEEE, MMM d, yyyy"
    
    var body: some View {
        VStack(alignment: .center) {
            BorrowBookHeader(model: viewModel.borrowBook, isRequest: false)
                .frame(height: 230)
            
            VStack(alignment: .leading) {
                TextWithIconInfo(icon: "mappin.and.ellipse", title: "Địa chỉ giao dịch", content: viewModel.borrowBook.traddingAddress)
                
                TextWithIconInfo(icon: "clock", title: "Thời điểm mượn", content: viewModel.borrowBook.borrowDate.getDate(format: formater))
                
                TextWithIconInfo(icon: "clock.arrow.circlepath", title: "Thời gian mượn", content: "\(viewModel.borrowBook.numOfDay) Ngày")
            }
            
            Spacer()
            
            if !viewModel.borrowBook.seen {
                HStack {
                    Button(action: {
                        viewModel.didDecline { (success) in
                            AppManager.shared.selectedIndex = 0
                        }
                    }, label: {
                        Text("Từ Chối")
                    })
                    .buttonStyle(BaseButtonStyle(size: .large, type: .secondary))
                    
                    Button(action: {
                        viewModel.didDecline { (success) in
                            AppManager.shared.selectedIndex = 2
                        }
                    }, label: {
                        Text("Đồng ý")
                    })
                    .buttonStyle(BaseButtonStyle(size: .large))
                }
                
                Spacer()
            }
        }
        .padding()
    }
}

struct ConfirmBorrowBookView_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmBorrowBookView()
    }
}
