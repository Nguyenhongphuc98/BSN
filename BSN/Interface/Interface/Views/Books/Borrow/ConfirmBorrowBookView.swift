//
//  ConfirmBorrowBookView.swift
//  Interface
//
//  Created by Phucnh on 10/8/20.
//

import SwiftUI

// View showing when click notify receive request from others
struct ConfirmBorrowBookView: View {
    
    var viewModel: ConfirmBorrowBookViewModel = ConfirmBorrowBookViewModel()
    
    var formater: String = "EEEE, MMM d, yyyy"
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showDeclineView: Bool = false
    
    var body: some View {
        VStack(alignment: .center) {
            BorrowBookHeader(model: viewModel.borrowBook, isRequest: false)
                .padding(.horizontal)
            
            VStack(alignment: .leading) {
                TextWithIconInfo(icon: "mappin.and.ellipse", title: "Địa chỉ giao dịch", content: viewModel.borrowBook.traddingAddress)
                
                TextWithIconInfo(icon: "clock", title: "Thời điểm mượn", content: viewModel.borrowBook.borrowDate.getDate(format: formater))
                
                TextWithIconInfo(icon: "clock.arrow.circlepath", title: "Thời gian mượn", content: "\(viewModel.borrowBook.numOfDay) Ngày")
            }
            
            Spacer()
            
            if !viewModel.borrowBook.seen {
                HStack(spacing: 30) {
                    Button(action: {
//                        viewModel.didDecline { (success) in
//                            AppManager.shared.selectedIndex = 0
//                        }
                        showDeclineView.toggle()
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
        .navigationBarTitle("Xem yêu cầu mượn sách", displayMode: .inline)
        .navigationBarHidden(false)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
        .sheet(isPresented: $showDeclineView, content: {
            DeclineEoBBookView()
        })
    }
    
    var backButton: some View {
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            Image(systemName: "chevron.backward")
                .foregroundColor(.gray)
        }
    }
}

struct ConfirmBorrowBookView_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmBorrowBookView()
    }
}
