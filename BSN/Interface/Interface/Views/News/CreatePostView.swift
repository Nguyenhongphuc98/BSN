//
//  CreatePostView.swift
//  Interface
//
//  Created by Phucnh on 9/29/20.
//

import SwiftUI

struct CreatePostView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var viewModel: CreatePostViewModel = CreatePostViewModel()
    
    @State var showCategory: Bool = false
    
    @State var showQuote: Bool = false
    
    @State var showPhotoPicker: Bool = false
    
    @State var content: String = ""
    
    @State var quote: String = ""
    
    var body: some View {
        ZStack {
            VStack {
                header
                
                editor
                
                // Progess bar (uploading)
                if viewModel.isUploading {
                    ProgressView("Đang xử lý ảnh", value: viewModel.uploadProgess, total: 1)
                        .progressViewStyle(LinearProgressViewStyle())
                        .padding()
                }
                
                footer
                
                Spacer()
            }
        }
        .embededLoading(isLoading: $viewModel.isLoading)
        .alert(isPresented: $viewModel.showAlert, content: alert)
    }
    
    private var header: some View {
        ZStack {
            HStack {
                Button {
                    self.presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .foregroundColor(.init(hex: 0x666666))
                }
                .disabled(viewModel.isUploading)
                
                Spacer()
                
                Button {
                    viewModel.didSaveSuccess = {
                        dismiss()
                    }
                    viewModel.post(content: content, quote: quote)
                } label: {
                    Text("Đăng")
                }
                .disabled(viewModel.isUploading)
            }
            .padding()
            .background(Rectangle().fill(Color.init(hex: 0xFAFAFA)))
            .shadow(color: Color.init(hex: 0xE8E8E8), radius: 2, x: 0, y: 1)
            
            Text("Tạo một bài viết")
                .font(.custom("Roboto-Bold", size: 13))
        }
    }
    
    private var editor: some View {
        VStack {
            if showQuote {
                QuoteEditor(message: $quote)
            }
            
            EditorWithPlaceHolder(text: $content, placeHolder: "Chia sẻ cảm xúc của bạn ngay nào", forceground: .black, font: "Roboto-Regular")
                .padding()
            
            if !viewModel.photoUrl.isEmpty {
                ZStack(alignment: .topTrailing) {
                    BSNImage(urlString: viewModel.photoUrl, tempImage: "unavailable")
                        .frame(width: 170, height: 120)
                        .cornerRadius(5)
                    
                    Button(action: {
                        self.viewModel.photoUrl = ""
                        self.viewModel.objectWillChange.send()
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color.blue)
                            .clipShape(Circle())
                    }
                }
            }
        }
    }
    
    private var footer: some View {
        HStack {
            Button {
                self.showCategory.toggle()
                print("did tap")
            } label: {
                HStack {
                    Image(systemName: "books.vertical")
                        .frame(width: 21, height: 21)
                    
                    Text(viewModel.category.name)
                        .robotoMedium(size: 11)
                }
                .foregroundColor(viewModel.category.id == kUndefine ? .black : .blue)
            }
            .buttonStyle(StrokeBorderStyle())
            .sheet(isPresented: $showCategory) {
                CategoryView { (category) in
                    self.viewModel.category = category
                    self.viewModel.objectWillChange.send()
                    print("Did tap: \(category)")
                }
            }
            
            Button {
                print("did tap")
                if showQuote == true {
                    // Changing to false (hiden)
                    quote = ""
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
            .disabled(!viewModel.photoUrl.isEmpty)
            .sheet(isPresented: $showPhotoPicker) {
                ImagePicker(picker: $showPhotoPicker) { img in
                    //viewModel.photo = data
                    viewModel.upload(image: img)
                }
            }
        }
    }
    
    private func alert() -> Alert {
        if viewModel.resourceInfo == .invalid_category
            || viewModel.resourceInfo == .invalid_empty
            || viewModel.resourceInfo == .image_upload_fail {
            
            return Alert(
                title: Text("Lỗi dữ liệu"),
                message: Text(viewModel.resourceInfo.des())
            )
        } else {
            
            // Failure to save post to server
            // Don't show alert when success
            return Alert(
                title: Text("Kết quả"),
                message: Text(viewModel.resourceInfo.des()),
                primaryButton: .default(Text("Thử lại")) {
                    if viewModel.resourceInfo == .savefailure {
                        viewModel.post(content: content, quote: quote)
                    }
                },
                secondaryButton: .cancel(Text("Huỷ bỏ")) {
                    dismiss()
                })
        }
    }
    
    private func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }
}

struct CreatePostView_Previews: PreviewProvider {
    static var previews: some View {
        CreatePostView()
    }
}
