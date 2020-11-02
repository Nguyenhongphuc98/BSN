//
//  SubmitRequestBorrowView.swift
//  Interface
//
//  Created by Phucnh on 10/6/20.
//

import SwiftUI

struct SubmitRequestBorrowView: View {
    
    @StateObject var viewModel: BorrowBookViewModel = BorrowBookViewModel()
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            BorrowBookHeader(model: viewModel.model.book)
                .padding(.top, 20)
                //.padding(.horizontal)
            
            Separator(color: .init(hex: 0xE2DFDF), height: 1)
                .padding(.horizontal, 30)
            
            Form {
                Section {
                    DatePicker(selection: $viewModel.borrowDate, in: ...Date(), displayedComponents: .date) {
                        Text("Thời điểm mượn")
                    }
                   
                    Picker("Thời gian mượn", selection: $viewModel.numOfDay) {
                            ForEach(1 ..< 30) {
                                Text("\($0) ngày")
                            }
                        }
                }
                
            }
            
            InputWithTitle(content: $viewModel.address, placeHolder: "Địa chỉ thuận tiện nhất cho giao dịch", title: "Địa chỉ giao dịch")
            
            InputWithTitle(content: $viewModel.message, placeHolder: "ex: Bạn ơi cho mình mượn cuốn này nhé!", title: "Lời nhắn")
            
            Button(action: {
                viewModel.didRequestBorrowBook { (success) in
                    dismiss()
                    AppManager.shared.selectedIndex = 1
                }
            }, label: {
                Text("    Hoàn tất    ")
            })
            .buttonStyle(BaseButtonStyle(size: .large))
            
            Spacer()
        }
        .padding(.horizontal)
        .background(Color(.secondarySystemBackground))
        .navigationBarTitle("Hoàn tất mượn sách", displayMode: .inline)
        .navigationBarHidden(false)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
    }
    
    var backButton: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "chevron.backward")
                .foregroundColor(.gray)
        }
    }
    
    func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }
}

struct SubmitRequestBorrowView_Previews: PreviewProvider {
    static var previews: some View {
        SubmitRequestBorrowView()
    }
}

// MARK: - Sub compoent
struct BorrowBookHeader: View {
    
    var model: BUserBook
    
    // Use for reuest or confirm View
    var isRequest: Bool = true
    
    var body: some View {
        VStack {
            HStack(alignment: .center, spacing: 20) {
                Image(model.cover!, bundle: interfaceBundle)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 100)
                    .background(Color.white)
                    .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.gray))
                
                VStack(alignment: .leading, spacing: 4) {
                    Spacer()
                    
                    Text(model.title)
                        .roboto(size: 15)
                    
                    Text(model.author)
                        .robotoLight(size: 14)
                    
                    HStack {
                        BookStatusText(status: model.status!)
                        Spacer()
                    }
                    
                    HStack {
                        Text("\(partnerRole) :")
                            .robotoLight(size: 14)
                            .layoutPriority(1)
                        
                        Text(model.ownerName!)
                            .robotoBold(size: 13)
                            .foregroundColor(._primary)
                    }
                }
            }
            .frame(height: 100)
            
            if isRequest {
                Text(model.statusDes)
                    .roboto(size: 13)
                    .padding(.vertical)
            }
        }
    }
    
    var partnerRole: String {
        isRequest ? "Chủ sở hữu" : "Người mượn"
    }
}
