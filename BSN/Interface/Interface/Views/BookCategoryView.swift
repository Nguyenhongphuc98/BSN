//
//  BookCategoryView.swift
//  Interface
//
//  Created by Phucnh on 9/29/20.
//

import SwiftUI

struct BookCategoryView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var viewModel: BookCategoryViewModel = BookCategoryViewModel()
    
    var didSelect: ((String) -> Void)?
    
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
                ForEach(viewModel.categories, id: \.self) { category in
                    HStack {
                        Text(category)
                            
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
    }
}

struct BookCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        BookCategoryView()
    }
}
