//
//  GuestBookDetailView.swift
//  Interface
//
//  Created by Phucnh on 1/11/21.
//

import SwiftUI

struct GuestBookDetailView: View {
    
    @StateObject var viewModel: GuestBookDetailViewModel = .init()
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var navState: NavigationState
    
    @State var showBorrowBook: Bool = false
    @State var showExchangeBook: Bool = false
    
    @State var expandStatus: Bool = true
    @State var expandExInfo: Bool = true
    
    var ubid: String
    
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                MyBookDetailViewHeader(model: viewModel.model, showDes: false)
                    .padding(.top, 10)
                
                bookStatus
                
                exchangeInfo
                
                actionBtn
                    .padding(.top)
            }
            .padding()
        }
        .embededLoading(isLoading: $viewModel.isLoading)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
        .navigationTitle(Text("Xem sách"))
        .onAppear(perform: viewAppeared)
    }
    
    var backButton: some View {
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            BackWardButton()
        }
    }
    
    private var bookStatus: some View {
        DisclosureGroup(
            isExpanded: $expandStatus,
            content: {
                Text(viewModel.model.statusDes)
                    .robotoItalic(size: 15)
                    .foregroundColor(.init(hex: 0x404040))
                    .multilineTextAlignment(.center)
                    .padding()
            }, label: {
                Text("Tình trạng sách").robotoBold(size: 19)
            })
            .padding(.trailing, 5)
    }
    
    private var exchangeInfo: some View {
        DisclosureGroup(
            isExpanded: $expandExInfo,
            content: {
                if viewModel.exchangeBook.id == kUndefine {
                    Text("Chủ sở hữu chưa muốn trao đổi cuốn sách này")
                        .robotoItalic(size: 15)
                        .foregroundColor(.init(hex: 0x404040))
                        .multilineTextAlignment(.center)
                        .padding()
                } else {
                    exchangeCard
                }
            }, label: {
                Text("Thông tin trao đổi").robotoBold(size: 19)
            })
            .padding(.trailing, 5)
    }
    
    private var exchangeCard: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 4) {
                Text(viewModel.exchangeBook.wantChangeBook?.title ?? "")
                    .roboto(size: 17)
                
                Text(viewModel.exchangeBook.wantChangeBook?.author ?? "")
                    .robotoLight(size: 14)
                
                Spacer()
            }
            .padding()
            
            BSNImage(urlString: viewModel.exchangeBook.wantChangeBook?.cover, tempImage: "book_cover")
                .frame(width: 66, height: 90)
                .background(Color.white)
                .id(viewModel.exchangeBook.wantChangeBook?.cover)
                .clipShape(RoundedRectangle(cornerRadius: 4))
                .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.gray))
        }
        .padding()
        .background(Color.init(hex: 0xeeeeee))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
    
    private var actionBtn: some View {
        HStack {
            NavigationLink(
                destination: SubmitRequestBorrowView(ubid: viewModel.model.id!).environmentObject(navState),
                isActive: $showBorrowBook,
                label: {
                    Text("Mượn sách")
                })
                .buttonStyle(BaseButtonStyle(size: .mediumH))
                .disabled(viewModel.model.state != .available)
            
            NavigationLink(
                destination: ExchangeBookView(ebID: viewModel.exchangeBook.id!) {
                    dismiss()
                },
                isActive: $showExchangeBook,
                label: {
                   Text("  Đổi sách  ")
                })
                .buttonStyle(BaseButtonStyle(size: .mediumH))
                .disabled(viewModel.exchangeBook.id == kUndefine)
        }
    }
    
    private func viewAppeared() {
        viewModel.prepareData(ubid: ubid)
    }
    
    private func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }
}

//struct GuestBookDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        GuestBookDetailView()
//    }
//}
