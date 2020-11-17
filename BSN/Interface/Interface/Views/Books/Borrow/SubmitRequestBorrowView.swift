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
    
    @EnvironmentObject private var navState: NavigationState
    
    @State private var disableSubmitBtn: Bool = false
    
    var ubid: String
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                BorrowBookHeader(model: viewModel.model.userbook)
                    .padding(.top, 20)
                
                Separator(color: .init(hex: 0xE2DFDF), height: 1)
                    .padding(.horizontal, 30)
                
                Form {
                    Section {
                        DatePicker(selection: $viewModel.borrowDate, in: Date()..., displayedComponents: .date) {
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
                    .onReceive(viewModel.$address) { (adress) in
                        self.disableSubmitBtn = adress.isEmpty
                    }
                
                InputWithTitle(content: $viewModel.message, placeHolder: "ex: Bạn ơi cho mình mượn cuốn này nhé!", title: "Lời nhắn")
                
                Button(action: {
                    viewModel.saveBorrowBook()
                }, label: {
                    Text("    Hoàn tất    ")
                })
                .buttonStyle(BaseButtonStyle(size: .large))
                .disabled(disableSubmitBtn)
                
                Spacer()
            }
        }
        .embededLoading(isLoading: $viewModel.isLoading)
        .padding(.horizontal)
        .background(Color(.secondarySystemBackground))
        .navigationBarTitle("Hoàn tất mượn sách", displayMode: .inline)
        .navigationBarHidden(false)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
        .alert(isPresented: $viewModel.showAlert, content: alert)
        .onAppear(perform: viewAppeared)
    }
    
    var backButton: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "chevron.backward")
                .foregroundColor(.gray)
        }
    }
    
    func alert() -> Alert {
        if viewModel.resourceInfo == .success {
            return Alert(
                title: Text("Kết quả"),
                message: Text(viewModel.resourceInfo.des()),
                dismissButton: .default(Text("OK")) {
                    popToBookDetail()
                })
        } else {
            
            return Alert(
                title: Text("Kết quả"),
                message: Text(viewModel.resourceInfo.des()),
                primaryButton: .default(Text("Thử lại")) {
                    // Resave borrowbook
                    viewModel.saveBorrowBook()
                },
                secondaryButton: .cancel(Text("Huỷ bỏ")) {
                    popToBookDetail()
                })
        }
    }
    
    private func viewAppeared() {
        print("Submit borrow book appeared")
        viewModel.prepareData(ubid: ubid)
    }
    
    private func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }
    
    private func popToBookDetail() {
        self.navState.popTo(viewName: .bookDetail)
    }
}

struct SubmitRequestBorrowView_Previews: PreviewProvider {
    static var previews: some View {
        SubmitRequestBorrowView(ubid: "---")
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
                BSNImage(urlString: model.cover, tempImage: "book_cover")
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
            .frame(height: 80)
            
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
