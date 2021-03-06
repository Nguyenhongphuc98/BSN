//
//  ConfirmBorrowBookView.swift
//  Interface
//
//  Created by Phucnh on 10/8/20.
//

import SwiftUI

// View showing when click notify receive request from others
struct ConfirmBorrowBookView: View {
    
    var bbid: String
    
    @StateObject var viewModel: ConfirmBorrowBookViewModel = .init()
    
    var formater: String = "EEEE, MMM d, yyyy"
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showResponseRequestView: Bool = false
    @State private var isAccept: Bool = false
    
    var body: some View {
        VStack(alignment: .center) {
            BorrowBookHeader(model: viewModel.borrowBook.userbook, isRequest: false, isShowForOwner: true)
                .padding(10)
            
            Text("\"\(viewModel.borrowBook.transactionInfo.message)\"")
                .roboto(size: 13)
                .padding(.vertical)
                .foregroundColor(.init(hex: 0x4C0098))
            
            VStack(alignment: .leading) {
                TextWithIconInfo(icon: "mappin.and.ellipse", title: "Địa chỉ giao dịch", content: viewModel.borrowBook.transactionInfo.adress)
                
                TextWithIconInfo(icon: "clock", title: "Thời điểm mượn", content: viewModel.borrowBook.transactionInfo.exchangeDate!.getDateStr(format: formater))
                
                TextWithIconInfo(icon: "clock.arrow.circlepath", title: "Thời gian mượn", content: "\(viewModel.borrowBook.transactionInfo.numDay!) Ngày")
            }
            .padding(.top)
            .padding(.horizontal)
            
            Spacer()
            
            if shouldShowAction(proges: viewModel.borrowBook.transactionInfo.progess) {
                HStack(spacing: 30) {
                    Button(action: {
                        isAccept = false
                        showResponseRequestView.toggle()
                    }, label: {
                        Text("   Từ Chối   ")
                    })
                    .buttonStyle(BaseButtonStyle(size: .large, type: .secondary))
                    
                    Button(action: {
//                        viewModel.didAccept()
//                        dismiss()
                        isAccept = true
                        showResponseRequestView.toggle()
                    }, label: {
                        Text("   Đồng ý   ")
                    })
                    .buttonStyle(BaseButtonStyle(size: .large))
                }
                
            } else {
                Text("Yêu cầu đã được \(viewModel.borrowBook.transactionInfo.progess.des())")
                    .robotoLight(size: 15)
            }
            Spacer()
        }
        .padding()
        .embededLoadingFull(isLoading: $viewModel.isLoading)
        .navigationBarTitle("Xem yêu cầu mượn sách", displayMode: .inline)
        .navigationBarHidden(false)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
        .sheet(isPresented: $showResponseRequestView, content: {
            ResponseEoBBookView(isAccept: isAccept, isBorrow: true, targetID: bbid) {
                dismiss()
            }
        })
        .onAppear(perform: viewAppeared)
    }
    
    var backButton: some View {
        Button {
            dismiss()
        } label: {
            BackWardButton()
        }
    }
    
    private func shouldShowAction(proges: ExchangeProgess) -> Bool {
        proges == .waiting
    }
    
    private func viewAppeared() {
        viewModel.prepareData(bbid: bbid)
    }
    
    private func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }
}

struct ConfirmBorrowBookView_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmBorrowBookView(bbid: "")
    }
}
