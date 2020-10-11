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
            BorrowBookHeader(model: viewModel.model)
                .padding(.top, 10)
                .padding(.horizontal)
            
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
            
            InputWithTitle(content: $viewModel.traddingAddress, placeHolder: "Địa chỉ thuận tiện nhất cho giao dịch", title: "Địa chỉ giao dịch")
            
            InputWithTitle(content: $viewModel.message, placeHolder: "ex: Bạn ơi cho mình mượn cuốn này nhé!", title: "Lời nhắn")
            
            Button(action: {
                viewModel.didRequestBorrowBook { (success) in
                    dismiss()
                    AppManager.shared.selectedIndex = 1
                }
            }, label: {
                Text("Hoàn tất")
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
    
    var model: BorrowBookDetail
    
    // Use for reuest or confirm View
    var isRequest: Bool = true
    
    // Use for result View
    // If it true, isRequest invalidate
    var isResultView: Bool = false
    
    var showSeperator: Bool = true
    
    var body: some View {
        VStack {
            HStack(alignment: .center, spacing: 20) {
                Image(model.book.photo, bundle: interfaceBundle)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 100)
                    .background(Color.white)
                    .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.gray))
                
                VStack(alignment: .leading, spacing: 4) {
                    Spacer()
                    
                    Text(model.book.name)
                        .roboto(size: 15)
                    
                    Text(model.book.author)
                        .robotoLight(size: 14)
                    
                    BookStatusText(status: model.status)
                    
                    HStack {
                        Text("\(partnerRole) :")
                            .robotoLight(size: 14)
                        
                        Text(model.owner.displayname)
                            .robotoBold(size: 13)
                            .foregroundColor(._primary)
                    }
                }
                
                Spacer()
            }
            
            if !isResultView {
                Text(description)
                    .roboto(size: 13)
                    .padding(.vertical)
                    .foregroundColor(isRequest ? .black : .init(hex: 0x4C0098))
            }
            
            if showSeperator {
                Separator(color: .init(hex: 0xE2DFDF), height: 1)
                    .padding(.horizontal, 50)
            }
        }
        .frame(height: height)
    }
    
    var description: String {
        isRequest ? model.statusDes : "\"\(model.statusDes)\""
    }
    
    var partnerRole: String {
        isRequest ? "Chủ sở hữu" : "Người mượn"
    }
    
    var height: CGFloat {
        isResultView ? 115 : 165
    }
}
