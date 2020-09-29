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
    
    @State var showPhotoPicker: Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                header
                
                editor
                
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
                        showPhotoPicker.toggle()
                    } label: {
                        HStack {
                            Image(systemName: "photo")
                                .frame(width: 21, height: 21)
                            
                            Text("Thêm ảnh")
                                .robotoMedium(size: 11)
                        }
                    }
                    .buttonStyle(StrokeBorderStyle())
                    .sheet(isPresented: $showPhotoPicker) {
                        ImagePicker(picker: $showPhotoPicker, img_Data: $viewModel.photo)
                    }
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
    
    var editor: some View {
        VStack {
            if showQuote {
                QuoteEditor(message: $viewModel.quote)
            }
            
            EditorWithPlaceHolder(text: $viewModel.content, placeHolder: "Chia sẻ cảm xúc của bạn ngay nào", forceground: .black, font: "Roboto-Regular")
                .padding()
            
            if !viewModel.photo.isEmpty {
                ZStack(alignment: .topTrailing) {
                    Image(uiImage: UIImage(data: viewModel.photo)!)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 180, height: 140)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                    
                    Button(action: {
                        self.viewModel.photo = Data()
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color("blue"))
                            .clipShape(Circle())
                    }
                }
            }
        }
    }
}

struct CreatePostView_Previews: PreviewProvider {
    static var previews: some View {
        CreatePostView()
    }
}
