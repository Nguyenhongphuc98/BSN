//
//  BookDetailBiew.swift
//  Interface
//
//  Created by Phucnh on 10/5/20.
//

import SwiftUI

struct BookDetailView: View {
    
    @StateObject var viewModel: BookDetailViewModel = BookDetailViewModel()
    
    @State var isExpandRating: Bool = true
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var showRatingView: Bool = false
    
    @State var showBorrowBook: Bool = false
    
    @State var showExchangeBook: Bool = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            NavigationLink(
                destination: BorrowListView(),
                isActive: $showBorrowBook,
                label: {
                    EmptyView()
                })
            
            NavigationLink(
                destination: ExchangeListView(),
                isActive: $showExchangeBook,
                label: {
                    EmptyView()
                })
        
            VStack() {
                basicInfo
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 10) {
                        Separator(height: 1)
                        
                        ratingDetail
                        
                        description
                        
                        reviews
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
    }
    
    private var basicInfo: some View {
        HStack(alignment: .center) {
            Image(viewModel.model.cover!, bundle: interfaceBundle)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 90, height: 130)
                .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.gray))
            
            VStack(alignment: .leading) {
                Text(viewModel.model.title)
                    .roboto(size: 15)
                
                Text(viewModel.model.author)
                    .robotoLight(size: 14)
                
                HStack {
                    StarRating(rating: viewModel.model.ratingCriteria.avg)
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
                    Button(action: {
                        showBorrowBook.toggle()
                    }, label: {
                        Text("Mượn sách")
                    })
                    .buttonStyle(BaseButtonStyle())
                    
                    Button(action: {
                        showExchangeBook.toggle()
                    }, label: {
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
                        Text("(\(String(format: "%.1f", viewModel.model.ratingCriteria.writing)))")
                            .robotoItalic(size: 15)
                            .foregroundColor(._primary)
                    }
                    
                    HStack {
                        Text("Có mục đích rõ ràng:")
                            .robotoItalic(size: 15)
                        Spacer()
                        StarRating(rating: viewModel.model.ratingCriteria.target)
                        Text("(\(String(format: "%.1f", viewModel.model.ratingCriteria.target)))")
                            .robotoItalic(size: 15)
                            .foregroundColor(._primary)
                    }
                    
                    HStack {
                        Text("Nhân vật chính lôi cuốn:")
                            .robotoItalic(size: 15)
                        Spacer()
                        StarRating(rating: viewModel.model.ratingCriteria.character)
                        Text("(\(String(format: "%.1f", viewModel.model.ratingCriteria.character)))")
                            .robotoItalic(size: 15)
                            .foregroundColor(._primary)
                    }
                    
                    HStack {
                        Text("Cung cấp thông tin hữu ích:")
                            .robotoItalic(size: 15)
                        Spacer()
                        StarRating(rating: viewModel.model.ratingCriteria.info)
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
                        RatingCell(model: review)
                        Separator(height: 1)
                    }
                }
                .padding(.leading, 5)
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
                showRatingView.toggle()
            }, label: {
                Text("Để lại đánh giá")
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
            RatingView(bookName: viewModel.model.title, bookID: viewModel.model.id!) { rating in
                viewModel.addNewRating(rate: rating)
            }
        })
    }
    
    var backButton: some View {
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            Image(systemName: "chevron.backward")
                .foregroundColor(.gray)
        }
    }
}

struct BookDetailBiew_Previews: PreviewProvider {
    static var previews: some View {
        BookDetailView()
    }
}
