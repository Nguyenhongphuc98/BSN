//
//  BookCategoryView.swift
//  Interface
//
//  Created by Phucnh on 9/29/20.
//

import SwiftUI

struct CategoryView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var viewModel: CategoryViewModel = .shared
    
    var didSelect: ((Category) -> Void)?
    
    var body: some View {
        VStack(alignment: .leading) {
            
            HStack {
                Spacer()
                
                Text("Chọn chủ đề sách")
                    .bold()
                    .padding()
                
                Spacer()
            }
            .background(Color.init(hex: 0xFAFAFA))
            .shadow(color: .gray, radius: 1, x: 0, y: 1)
            
            List {
                ForEach(viewModel.categories, id: \.id) { category in
                    HStack {
                        Text(category.name)
                            
                        Spacer()
                    }
                    .background(Color.white)
                    .onTapGesture {
                        self.presentationMode.wrappedValue.dismiss()
                        didSelect?(category)
                    }
                    
                }
            }
            
            Spacer()
        }
        .embededLoadingFull(isLoading: $viewModel.isLoading)
    }
}

struct BookCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryView()
    }
}
