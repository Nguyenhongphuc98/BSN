//
//  BookGrid.swift
//  Interface
//
//  Created by Phucnh on 10/5/20.
//

import SwiftUI

struct BookGrid: View {
    
    var models: [Book]
    
    var hasFooter: Bool = false
    
    var isOwner: Bool = true
    
    var columns: [GridItem] = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]
    
    // Did select book have name 'Book'
    var didSelect: ((Book) -> Void)?
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, content: {
                ForEach(models) { book in
                    VStack {
                        BookCard(model: book)
                            .padding(.bottom, 5)
                            .padding(.trailing, 3)
                        
                        if hasFooter {
                            if isOwner {
                                Button(action: {
                                    print("did click borrow book")
                                }, label: {
                                    Text(" Đổi sách  ")
                                })
                                .buttonStyle(BaseButtonStyle(size: .mediumH))
                            } else {
                                Button(action: {
                                    print("did click exchange book")
                                }, label: {
                                    Text("Mượn sách")
                                })
                                .buttonStyle(BaseButtonStyle(size: .mediumH))
                            }
                        }
                    }
                    .padding(.bottom)
                }
            })
        }
        .padding(.horizontal)
        .background(Color.white)
    }
}

struct BookGrid_Previews: PreviewProvider {
    static var previews: some View {
        BookGrid(models: [Book(), Book(), Book(), Book()])
    }
}
