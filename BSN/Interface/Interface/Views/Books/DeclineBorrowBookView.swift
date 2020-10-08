//
//  DeclineBorrowBook.swift
//  Interface
//
//  Created by Phucnh on 10/8/20.
//

import SwiftUI

struct DeclineBorrowBookView: View {
    
    @StateObject var viewModel: DeclineBorrowBookViewModel = DeclineBorrowBookViewModel()
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 20) {
                Text("Từ chối mượn sách")
                    .robotoBold(size: 18)
                
                Text("Hãy để lại lý do bạn từ chối để bạn đọc hiểu chuyện gì đang xảy ra nhé")
                    .roboto(size: 15)
                    .multilineTextAlignment(.center)
                    .padding(.top)
                
                EditorWithPlaceHolder(text: $viewModel.declineMessage, placeHolder: "Để lại lời nhắn của bạn tại đây")
                    .frame(height: 100)
                    .cornerRadius(5)
                    .padding()
                
                Spacer()
                
                Button(action: {
                    viewModel.processDecline { (success) in
                        print("did process: \(viewModel.declineMessage) - \(success)")
                        presentationMode.wrappedValue.dismiss()
                    }
                }, label: {
                    Text("Hoàn tất")
                })
                .buttonStyle(BaseButtonStyle(size: .large))
                
                Spacer()
            }
            .padding()
            
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Huỷ")
                        .padding()
                })
                
                Spacer()
            }
        }
        .background(Color(.secondarySystemBackground))
    }
}

struct DeclineBorrowBook_Previews: PreviewProvider {
    static var previews: some View {
        DeclineBorrowBookView()
    }
}
