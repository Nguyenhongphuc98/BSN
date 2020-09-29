//
//  CreatePostView.swift
//  Interface
//
//  Created by Phucnh on 9/29/20.
//

import SwiftUI

struct CreatePostView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var viewModel: CreatePostViewModel = CreatePostViewModel()
    
    @State var showCategory: Bool = false
    
    @State var showQuote: Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                header
                
                if showQuote {
                    QuoteEditor(message: $viewModel.quote)
                }
                
                EditorWithPlaceHolder(text: $viewModel.content, placeHolder: "Chia sẻ cảm xúc của bạn ngay nào", forceground: .black, font: "Roboto-Regular")
                    .padding()
                
                HStack {
                    Button {
                        self.showCategory.toggle()
                        print("did tap")
                    } label: {
                        HStack {
                            Image(systemName: "books.vertical")
                                .frame(width: 21, height: 21)
                            
                            Text(viewModel.category == fakeCategory[0] ? "Chọn chủ đề" : viewModel.category)
                                .robotoMedium(size: 11)
                        }
                        .foregroundColor(viewModel.category == fakeCategory[0] ? .black : .blue)
                    }
                    .buttonStyle(StrokeBorderStyle())
                    .sheet(isPresented: $showCategory) {
                        BookCategoryView { (category) in
                            self.viewModel.category = category
                            print("Did tap: \(category)")
                        }
                    }
                    
                    Button {
                        print("did tap")
                        if showQuote == true {
                            // Changing to false (hiden)
                            viewModel.quote = ""
                        }
                        withAnimation {
                            self.showQuote.toggle()
                        }
                    } label: {
                        HStack {
                            Image(systemName: "quote.bubble")
                                .frame(width: 21, height: 21)
                            
                            Text("Thêm trích dẫn")
                                .robotoMedium(size: 11)
                        }
                        .foregroundColor(showQuote ? .blue : .black)
                    }
                    .buttonStyle(StrokeBorderStyle())
                    
                    Button {
                        print("did tap")
                    } label: {
                        HStack {
                            Image(systemName: "photo")
                                .frame(width: 21, height: 21)
                            
                            Text("Thêm ảnh")
                                .robotoMedium(size: 11)
                        }
                    }
                    .buttonStyle(StrokeBorderStyle())
                }
                
                Spacer()
            }
            
            if viewModel.isPosting {
                Loading()
            }
        }
    }
    
    var header: some View {
        ZStack {
            HStack {
                Button {
                    self.presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .foregroundColor(.init(hex: 0x666666))
                }
                
                Spacer()
                
                Button {
                    viewModel.post { (result) in
                        print("did post")
                        self.presentationMode.wrappedValue.dismiss()
                    }
                } label: {
                    Text("Đăng")
                }
            }
            .padding()
            .background(Rectangle().fill(Color.init(hex: 0xFAFAFA)))
            .shadow(color: Color.init(hex: 0xE8E8E8), radius: 2, x: 0, y: 1)
            
            Text("Tạo một bài viết")
                .font(.custom("Roboto-Bold", size: 13))
        }
    }
}

struct CreatePostView_Previews: PreviewProvider {
    static var previews: some View {
        CreatePostView()
    }
}
