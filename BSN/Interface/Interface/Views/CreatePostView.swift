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
    
    var body: some View {
        ZStack {
            VStack {
                header
                
                QuoteEditor(message: $viewModel.quote)
                
                TextEditor(text: $viewModel.content)
                    .frame(maxHeight: 60)
                
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
