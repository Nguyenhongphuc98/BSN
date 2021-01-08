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
    
    @StateObject var viewModel: RatingViewModel = .init()
    
    var didRating: (() -> Void)?
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var processReview: Rating
    
    //@State var lastMessage: String = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Đánh giá \(bookName)")
                .robotoBold(size: 17)
                .padding()
            
            ScrollView(showsIndicators: false) {
                VStack {
                    SubRatingItem(
                        icon: "newspaper",
                        title: "Giọng văn cuốn hút",
                        rating: processReview.writeRating) { rate in
                        
                        viewModel.rating.writing = Float(rate)
                    }
                    
                    SubRatingItem(
                        icon: "target",
                        title: "Có mục đích rõ ràng",
                        rating: processReview.targetRating) { rate in
                        
                        viewModel.rating.target = Float(rate)
                    }
                    
                    SubRatingItem(
                        icon: "person.fill.checkmark",
                        title: "Nhân vật chính lôi cuốn",
                        rating: processReview.characterRating) { rate in
                        
                        viewModel.rating.character = Float(rate)
                    }
                    
                    SubRatingItem(
                        icon: "info.circle",
                        title: "Cung cấp thông tin hữu ích",
                        rating: processReview.infoRating) { rate in
                        
                        viewModel.rating.info = Float(rate)
                    }
                    
                    TextField("Mô tả ngắn (tiêu đề)", text: $viewModel.title)
                        .padding()
                        .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color._primary))
                    
                    CoreMessageEditor(
                        message: processReview.content,
                        placeHolder: "Để lại đánh giá của bạn tại đây") { (message) in
                        
                        viewModel.lastMessage = message
                        viewModel.didRating(message: viewModel.lastMessage, bookID: bookID, processRating: processReview)
                    }
                    
                    Spacer()
                }
                .padding()
            }
        }
        .embededLoading(isLoading: $viewModel.isLoading)
        .alert(isPresented: $viewModel.showAlert, content: alert)
        .onAppear(perform: viewAppeared)
    }
    
    func alert() -> Alert {
        if viewModel.resourceInfo == .success {
            return Alert(
                title: Text("Kết quả"),
                message: Text(viewModel.resourceInfo.des()),
                dismissButton: .default(Text("OK")) {
                    didRating?()
                    dismiss()
                })
        } else {
            
            return Alert(
                title: Text("Kết quả"),
                message: Text(viewModel.resourceInfo.des()),
                primaryButton: .default(Text("Thử lại")) {
                    // it actualy just save
                    viewModel.didRating(message: viewModel.lastMessage, bookID: bookID, processRating: processReview)
                },
                secondaryButton: .cancel(Text("Huỷ bỏ")) {
                    dismiss()
                })
        }
    }
    
    private func dismiss() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    private func viewAppeared() {
        print("Book review appeared")
        viewModel.setupIfNeeded(r: processReview)
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
    
    @State var rating: Int = 0
    
    var didRate: ((Int) -> Void)?
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 25))
            
            
            VStack(alignment: .leading) {
                Text(title)
                    .robotoBold(size: 17)
                
                HStack {
                    ForEach(1..<6) { i in
                        Image(systemName: i <= rating ? "star.fill" : "star")
                            .foregroundColor(i <= rating ? .yellow : .gray)
                            .onTapGesture(perform: {
                                rating = i
                                didRate?(rating)
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
