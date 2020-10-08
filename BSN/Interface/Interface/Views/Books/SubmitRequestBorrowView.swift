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
            
            Form {
                Section {
                    DatePicker(selection: $viewModel.borrowDate, in: ...Date(), displayedComponents: .date) {
                        Text("Thời gian mượn")
                    }
                   
                    Picker("Số ngày mượn", selection: $viewModel.numOfDay) {
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
    
    // use for reuest or confirm View
    var isRequest: Bool = true
    
    var leftAvatar: String {
        isRequest ? AppManager.shared.currentUser.avatar : model.owner.avatar
    }
    
    var rightAvatar: String {
        isRequest ? model.owner.avatar : AppManager.shared.currentUser.avatar
    }
    
    var body: some View {
        VStack {
            HStack(spacing: 30) {
                CircleImage(image: leftAvatar, diameter: 60)
                
                Text("Yêu cầu mượn")
                    .roboto(size: 18)
                
                CircleImage(image: rightAvatar, diameter: 60)
            }
            
            HStack(alignment: .center) {
                Image(model.book.photo, bundle: interfaceBundle)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 100)
                    .background(Color.white)
                    .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.gray))
                
                VStack(alignment: .leading) {
                    Spacer()
                    
                    Text(model.book.name)
                        .roboto(size: 15)
                    
                    Text(model.book.author)
                        .robotoLight(size: 14)
                    
                    BookStatusText(status: model.status)
                }
                
                Spacer()
            }
            
            Text(model.statusDes)
                .roboto(size: 13)
                .padding(.vertical)
            
            Separator(color: .init(hex: 0xE2DFDF), height: 1)
                .padding(.horizontal, 50)
        }
    }
}
