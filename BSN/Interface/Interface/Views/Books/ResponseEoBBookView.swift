//
//  DeclineBorrowBook.swift
//  Interface
//
//  Created by Phucnh on 10/8/20.
//

import SwiftUI

// View showing when decline/accept request borrow or exchange book
struct ResponseEoBBookView: View {
    
    @StateObject var viewModel: ResponseEoBBookViewModel = ResponseEoBBookViewModel()
    
    @Environment(\.presentationMode) var presentationMode
    
    var isAccept: Bool = true
    var isBorrow: Bool = true
    
    var targetID: String // id of borrow book / exchange book
    
    var didSubmit: (() -> Void)?
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 20) {
                Text("\(isAccept ? "Chấp nhận" : "Từ chối") yêu cầu \(isBorrow ? "mượn" : "đổi") sách")
                    .robotoBold(size: 18)
                    .padding()
                
                Text(des)
                    .roboto(size: 15)
                    .multilineTextAlignment(.center)
                    .padding(.top)
                
                EditorWithPlaceHolder(text: $viewModel.declineMessage, placeHolder: "Để lại lời nhắn của bạn tại đây")
                    .frame(height: 100)
                    .cornerRadius(5)
                    .padding()
                
                Spacer()
                
                Button(action: {
                    if isAccept {
                        viewModel.processAccept(isborrow: isBorrow, targetID: targetID)
                    } else {
                        viewModel.processDecline(isborrow: isBorrow, targetID: targetID)
                    }
                    
                    didSubmit?()
                    dismiss()
                }, label: {
                    Text("Hoàn tất")
                })
                .buttonStyle(BaseButtonStyle(size: .large))
                
                Spacer()
            }
            .padding()
            
            HStack {
                Button(action: {
                    dismiss()
                }, label: {
                    Text("Huỷ")
                        .padding()
                })
                
                Spacer()
            }
        }
        .background(Color(.secondarySystemBackground))
    }
    
    private var des: String {
        isAccept ? "Hãy để lại lưu ý/lời nhắn của bạn" : "Hãy để lại lý do bạn từ chối\n để bạn đọc hiểu chuyện gì đang xảy ra nhé"
    }
    
    private func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }
}

struct DeclineBorrowBook_Previews: PreviewProvider {
    static var previews: some View {
        ResponseEoBBookView(targetID: "")
    }
}
