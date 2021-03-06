//
//  BookDetailBiew.swift
//  Interface
//
//  Created by Phucnh on 10/5/20.
//

import SwiftUI

struct BookDetailView: View, PopToable {
    // Pop able
    var viewName: ViewName = .bookDetail
    @EnvironmentObject var navState: NavigationState
    
    // Main properties
    @StateObject var viewModel: BookDetailViewModel = .init()
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var isExpandRating: Bool = true
    @State var showRatingView: Bool = false
    @State var showBorrowBook: Bool = false
    @State var showExchangeBook: Bool = false
    
    var bookID: String
    @StateObject private var passthroughtRating: Rating = .init()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack() {
                basicInfo

                Separator(height: 1)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 10) {
                        ratingDetail

                        description

                        reviews
                        
                        Spacer()
                    }
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 58)

            reviewButton
        }
        .navigationBarTitle("Chi tiết sách", displayMode: .inline)
        .navigationBarHidden(false)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
        .embededLoading(isLoading: $viewModel.isLoading)
        .alert(isPresented: $viewModel.showAlert, content: alert)
        .onAppear(perform: viewAppeared)
//        .onReceive(navState.$viewName) { (viewName) in
//            if viewName == self.viewName {
//                self.showBorrowBook = false
//                self.showExchangeBook = false
//            }
//        }
    }
    
    private var basicInfo: some View {
        HStack(alignment: .center) {
            BSNImage(urlString: viewModel.model.cover, tempImage: "book_cover")
                .frame(width: 90, height: 130)
                .id(viewModel.model.cover)
                .clipShape(RoundedRectangle(cornerRadius: 4))
                .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.gray))
            
            VStack(alignment: .leading) {
                Text(viewModel.model.title)
                    .roboto(size: 15)

                Text(viewModel.model.author)
                    .robotoLight(size: 14)

                HStack {
                    StarRating(rating: viewModel.model.avgRating)
                        .id(UUID())
                    Text(String(format: "%.1f", viewModel.model.ratingCriteria.avg))
                        .roboto(size: 15)
                }
                
                HStack {
                    Text("\(viewModel.model.numReading)")
                        .roboto(size: 15)
                    Image("reading", bundle: interfaceBundle)
                        .resizable()
                        .frame(width: 20, height: 20)
                    Text("Đang đọc")
                        .font(.system(size: 17))
                        .foregroundColor(Color.init(hex: 0xAFAFAF))
                    
                    Text("\(viewModel.model.numAvailable)")
                        .roboto(size: 15)
                    Image(systemName: "text.book.closed")
                    Text("Có sẵn")
                        .font(.system(size: 17))
                        .foregroundColor(Color.init(hex: 0xAFAFAF))
                }
                
                HStack {
                    NavigationLink(
                        destination: BorrowListView(bid: bookID).environmentObject(navState),
                        isActive: $showBorrowBook,
                        label: {
                            Text("Mượn sách")
                        })
                        .buttonStyle(BaseButtonStyle())
                    
                    NavigationLink(
                        destination: ExchangeListView(bid: bookID).environmentObject(navState),
                        isActive: $showExchangeBook,
                        label: {
                           Text("  Đổi sách  ")
                        })
                        .buttonStyle(BaseButtonStyle())
                }
            }
            
            Spacer()
        }
        .frame(height: 130)
        .padding(.top)
    }
    
    private var ratingDetail: some View {
        DisclosureGroup(
            isExpanded: $isExpandRating,
            content: {
                VStack(alignment: .leading) {
                    HStack {
                        Text("Giọng văn cuốn hút:")
                            .robotoItalic(size: 15)
                        Spacer()
                        
                        StarRating(rating: viewModel.model.ratingCriteria.writing)
                            .id(UUID())
                        
                        Text("(\(String(format: "%.1f", viewModel.model.ratingCriteria.writing)))")
                            .robotoItalic(size: 15)
                            .foregroundColor(._primary)
                    }
                    
                    HStack {
                        Text("Có mục đích rõ ràng:")
                            .robotoItalic(size: 15)
                        Spacer()
                        
                        StarRating(rating: viewModel.model.ratingCriteria.target)
                            .id(UUID())
                        
                        Text("(\(String(format: "%.1f", viewModel.model.ratingCriteria.target)))")
                            .robotoItalic(size: 15)
                            .foregroundColor(._primary)
                    }
                    
                    HStack {
                        Text("Nhân vật chính lôi cuốn:")
                            .robotoItalic(size: 15)
                        Spacer()
                        
                        StarRating(rating: viewModel.model.ratingCriteria.character)
                            .id(UUID())
                        
                        Text("(\(String(format: "%.1f", viewModel.model.ratingCriteria.character)))")
                            .robotoItalic(size: 15)
                            .foregroundColor(._primary)
                    }
                    
                    HStack {
                        Text("Cung cấp thông tin hữu ích:")
                            .robotoItalic(size: 15)
                        Spacer()
                        
                        StarRating(rating: viewModel.model.ratingCriteria.info)
                            .id(UUID())
                        
                        Text("(\(String(format: "%.1f", viewModel.model.ratingCriteria.info)))")
                            .robotoItalic(size: 15)
                            .foregroundColor(._primary)
                    }
                }
                .foregroundColor(.init(hex: 0x404040))
                .padding(.trailing)
                .padding(.leading, 2)
            },
            label: {
                Text("Đánh giá chi tiết")
                    .robotoBold(size: 19)
            }
        )
        .padding(.trailing, 5)
    }
    
    private var description: some View {
        DisclosureGroup(
            content: {
                Text(viewModel.model.description!)
                    .robotoItalic(size: 15)
                    .foregroundColor(.init(hex: 0x404040))
            },
            label: {
                Text("Giới thiệu sách")
                    .robotoBold(size: 19)
            }
        )
        .padding(.trailing, 5)
    }
    
    private var reviews: some View {
        DisclosureGroup(
            content: {
                ForEach(viewModel.reviews) { review in
                    VStack {
                        ZStack(alignment: .topTrailing) {
                            RatingCell(model: review)
                                .id(UUID())
                            
                            if review.authorID == AppManager.shared.currenUID {
                                Menu {
                                    Button {
                                        viewModel.deleteReview(rid: review.id)
                                        passthroughtRating.clear()
                                    } label: {
                                        Text("Xoá đánh giá")
                                    }
                                }
                                label: {
                                    // More button
                                    Image(systemName: "ellipsis").padding()
                                }
                            }
                        }
                        
                        Separator(height: 1)
                    }
                }
                .padding(.leading, 5)
                .padding(.vertical)
            },
            label: {
                Text("Có tất cả \(viewModel.reviews.count) đánh giá")
                    .robotoBold(size: 19)
            }
        )
        .padding(.trailing, 5)
    }
    
    private var reviewButton: some View {
        HStack {
            Spacer()
            Button(action: {
                if let r = viewModel.getReiviewOfcurrentUser() {
                    passthroughtRating.clone(other: r)
                }
                showRatingView.toggle()
            }, label: {
                Text("\(viewModel.reviewed ? "Sửa" : "Tạo") đánh giá")
            })
            .buttonStyle(BaseButtonStyle(size:.large))
            
            Spacer()
        }
        .padding(8)
        .background(
            Color(UIColor.secondarySystemBackground)
        )
        .shadow(radius: 2, y: -2)
        .sheet(isPresented: $showRatingView, content: {
            RatingView(bookName: viewModel.model.title, bookID: viewModel.model.id!) {
                
                // Did rating
                passthroughtRating.clear()
                viewModel.reloadData()
            }
            .environmentObject(passthroughtRating)
        })
    }
    
    var backButton: some View {
        Button {
            ExploreBookViewModel.shared.reloadTopBooks()
            presentationMode.wrappedValue.dismiss()
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
                    dismiss()
                })
        } else {
            
            return Alert(
                title: Text("Kết quả"),
                message: Text(viewModel.resourceInfo.des()),
                primaryButton: .default(Text("Thử lại")) {
                    // depen load or save
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
        print("Book detail appeared")
        viewModel.prepareData(bid: bookID)
    }
}

struct BookDetailBiew_Previews: PreviewProvider {
    static var previews: some View {
        BookDetailView(bookID: "bid")
    }
}
