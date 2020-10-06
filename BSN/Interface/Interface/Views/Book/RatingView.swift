//
//  RatingView.swift
//  Interface
//
//  Created by Phucnh on 10/6/20.
//

import SwiftUI

// MARK: - Rating View
struct RatingView: View {
    
    var bookName: String
    
    var bookID: String
    
    @StateObject var viewModel: RatingViewModel = RatingViewModel()
    
    var didRating: ((Rating) -> Void)?
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Đánh giá \(bookName)")
                .robotoBold(size: 17)
                .padding()
            
            Spacer()
            
            SubRatingItem(icon: "newspaper", title: "Giọng văn cuốn hút") { rate in
                viewModel.rating.writing = Float(rate)
            }
            
            SubRatingItem(icon: "target", title: "Có mục đích rõ ràng") { rate in
                viewModel.rating.target = Float(rate)
            }
            
            SubRatingItem(icon: "person.fill.checkmark", title: "Nhân vật chính lôi cuốn") { rate in
                viewModel.rating.character = Float(rate)
            }
            
            SubRatingItem(icon: "info.circle", title: "Cung cấp thông tin hữu ích") { rate in
                viewModel.rating.info = Float(rate)
            }
            
            TextField("Mô tả ngắn (tiêu đề)", text: $viewModel.title)
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color._primary))
            
            CoreMessageEditor(placeHolder: "Để lại đánh giá của bạn tại đây") { (message) in
                viewModel.didRating(message: message, bookID: bookID) { (rate) in
                    didRating?(rate)
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
        .padding()
    }
}

struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        RatingView(bookName: "Cuộc sống xa nhà", bookID: "")
    }
}

// MARK: - Sub Item
struct SubRatingItem: View {
    
    var icon: String
    
    var title: String
    
    var didRate: ((Int) -> Void)?
    
    @State private var rating: Int = 5
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 25))
            
            
            VStack(alignment: .leading) {
                Text(title)
                    .robotoBold(size: 17)
                
                HStack {
                    ForEach(0..<rating) { i in
                        Image(systemName: i <= rating ? "star.fill" : "star")
                            .foregroundColor(i <= rating ? .yellow : .gray)
                            .onTapGesture(perform: {
                                rating = i
                                didRate?(i)
                            })
                    }
                }
            }
            .padding(.horizontal)
            Spacer()
        }
        .padding()
        .background(Color.init(hex: 0xF6F6F6))
        .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color._primary))
    }
}
