//
//  ExchangeBookJustVView.swift
//  Interface
//
//  Created by Phucnh on 10/9/20.
//

import SwiftUI

// Submit request exchange book View on available transaction
struct ExchangeBookView: View {
    
    @StateObject var viewModel: ExchangeBookViewModel = ExchangeBookViewModel()
    
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject private var navState: NavigationState
    
    var exploreVM: ExploreBookViewModel?
    
    var ebID: String
    
    var didsuccess: (() -> Void)?
    
    var body: some View {
        ScrollView(showsIndicators: false, content: {
            VStack {
                BorrowBookHeader(model: viewModel.exchangeBook.needChangeBook, isShowForOwner: false)
                    .padding(.vertical)
                
                Image(systemName: "repeat")
                    .foregroundColor(._primary)
                    .padding(.horizontal)
                    .font(.system(size: 28))
                
                ExchangeBookSecondHeader(model: viewModel.exchangeBook.wantChangeBook!)
                
                Group {
                    if viewModel.canExchange {
                        InputWithTitle(content: $viewModel.traddingAdress, placeHolder: "Địa chỉ thuận tiện nhất cho giao dịch", title: "Địa chỉ giao dịch")
                        
                        InputWithTitle(content: $viewModel.message, placeHolder: "ex: Bạn ơi cho mình đổi cuốn này nhé!", title: "Lời nhắn")
                        
                        Button(action: {
                            viewModel.requestExchangeBook()
                        }, label: {
                            Text("   Hoàn tất   ")
                        })
                        .buttonStyle(BaseButtonStyle(size: .largeH))
                        .padding()
                        
                    } else {
                        Spacer(minLength: 80)
                            
                        Button(action: {
                            dismiss()
                        }, label: {
                            Text("    Quay lại    ")
                        })
                        .buttonStyle(BaseButtonStyle(size: .largeH))
                    }
                }
                
                Spacer()
            }
        })
        .padding()
        .embededLoading(isLoading: $viewModel.isLoading)
        .alert(isPresented: $viewModel.showAlert, content: alert)
        .navigationBarTitle("Hoàn tất đổi sách", displayMode: .inline)
        .navigationBarHidden(false)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
        .onAppear(perform: viewAppeared)
        .transition(.opacity)
    }
    
    private var backButton: some View {
        Button {
            dismiss()
        } label: {
            BackWardButton()
        }
    }
    
    func alert() -> Alert {
        if viewModel.resourceInfo == .success {
            return Alert(
                title: Text("Kết quả"),
                message: Text(viewModel.resourceInfo.des()),
                dismissButton: .default(Text("OK")) {
                    exploreVM?.removeEB(ebid: viewModel.exchangeBook.id!)
                    didsuccess?()
                    dismiss()
                })
        } else {
            
            return Alert(
                title: Text("Kết quả"),
                message: Text(viewModel.resourceInfo.des()),
                primaryButton: .default(Text("Thử lại")) {
                    viewModel.requestExchangeBook()
                },
                secondaryButton: .cancel(Text("Huỷ bỏ")) {
                    dismiss()
                })
        }
    }
    
    private func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }
    
    private func viewAppeared() {
        print("Exchange book detail - submit available transaction appeared")
        viewModel.prepareData(ebID: ebID)
    }
}

struct ExchangeBookJustVView_Previews: PreviewProvider {
    static var previews: some View {
        ExchangeBookView(ebID: "uuid")
    }
}

// MARK: - Second header
struct ExchangeBookSecondHeader: View {
    
    var model: BUserBook
    
    var isRequest: Bool = true
    
    var body: some View {
        VStack {
            HStack(spacing: 20) {
                Spacer()
                
                VStack(alignment: .leading, spacing: 4) {
                    Spacer()
                    
                    Text(model.title)
                        .roboto(size: 15)
                    
                    Text(model.author)
                        .robotoLight(size: 14)
                    
                    if model.id != nil {
                        if isRequest {
                            BookStatusText(status: model.status!)
                        } else {
                            HStack {
                                Text("Chủ sở hữu:")
                                    .robotoLight(size: 14)
                                    .layoutPriority(1)
                                
                                Text(model.ownerName ?? "unknown")
                                    .robotoBold(size: 13)
                                    .foregroundColor(._primary)
                            }
                        }
                    } else {
                        Text("Bạn không có cuốn sách này")
                            .robotoBold(size: 14)
                            .foregroundColor(.init(hex: 0xFF6D1B))
                    }
                }
                
                BSNImage(urlString: model.cover, tempImage: "book_cover")
                    .id(model.cover!)
                    .frame(width: 80, height: 110)
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                    .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.gray))                    
            }
            
            if model.id != nil {
                Text(model.statusDes)
                    .roboto(size: 13)
                    .padding(.vertical)
                    .foregroundColor(.black)
            }
        }
        .frame(height: height)
    }
    
    var height: CGFloat {
        (model.id != nil) ? 155 : 100
    }
}

//struct ExchangeBookSecondHeader_Previews: PreviewProvider {
//    static var previews: some View {
//        ExchangeBookSecondHeader(model: BorrowBookDetail(), isCanChange: true)
//    }
//}
