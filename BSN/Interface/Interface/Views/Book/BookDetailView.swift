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
    
    var body: some View {
        ZStack(alignment: .bottom) {
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
            Image(viewModel.model.photo, bundle: interfaceBundle)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80, height: 130)
                .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.gray))
            
            VStack(alignment: .leading) {
                Text(viewModel.model.name)
                    .roboto(size: 15)
                
                Text(viewModel.model.author)
                    .robotoLight(size: 14)
                
                HStack {
                    StarRating(rating: viewModel.model.rating)
                    Text(String(format: "%.1f", viewModel.model.rating))
                        .roboto(size: 15)
                }
                
                HStack {
                    Text("\(viewModel.model.numReading)")
                        .roboto(size: 15)
                    Image("reading", bundle: interfaceBundle)
                        .resizable()
                        .frame(width: 23, height: 23)
                    Text("Đang đọc")
                        .foregroundColor(Color.init(hex: 0xAFAFAF))
                    
                    Text("\(viewModel.model.numReading)")
                        .roboto(size: 15)
                    Image(systemName: "text.book.closed")
                    Text("Có sẵn")
                        .foregroundColor(Color.init(hex: 0xAFAFAF))
                }
                
                HStack {
                    Button(action: {
                        
                    }, label: {
                        Text("Mượn sách")
                    })
                    .buttonStyle(BaseButtonStyle())
                    
                    Button(action: {
                        
                    }, label: {
                        Text("Đổi sách")
                    })
                    .buttonStyle(BaseButtonStyle())
                }
            }
            
            Spacer()
        }
        .frame(height: 135)
        .padding(.vertical)
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
                        StarRating(rating: viewModel.model.writingRate)
                        Text("(\(String(format: "%.1f", viewModel.model.writingRate)))")
                            .robotoItalic(size: 15)
                            .foregroundColor(._primary)
                    }
                    
                    HStack {
                        Text("Có mục đích rõ ràng:")
                            .robotoItalic(size: 15)
                        Spacer()
                        StarRating(rating: viewModel.model.targetRate)
                        Text("(\(String(format: "%.1f", viewModel.model.targetRate)))")
                            .robotoItalic(size: 15)
                            .foregroundColor(._primary)
                    }
                    
                    HStack {
                        Text("Nhân vật chính lôi cuốn:")
                            .robotoItalic(size: 15)
                        Spacer()
                        StarRating(rating: viewModel.model.characterRate)
                        Text("(\(String(format: "%.1f", viewModel.model.characterRate)))")
                            .robotoItalic(size: 15)
                            .foregroundColor(._primary)
                    }
                    
                    HStack {
                        Text("Cung cấp thông tin hữu ích:")
                            .robotoItalic(size: 15)
                        Spacer()
                        StarRating(rating: viewModel.model.infoRate)
                        Text("(\(String(format: "%.1f", viewModel.model.infoRate)))")
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
                Text(viewModel.model.description)
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
                        RatingItem(model: review)
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
                
            }, label: {
                Text("Để lại đánh giá")
            })
            .buttonStyle(BaseButtonStyle(size:.big))
            
            Spacer()
        }
        .padding(8)
        .background(
            Color(UIColor.secondarySystemBackground)
        )
        .shadow(color: .gray, radius: 2, y: -2)
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
