//
//  BookGrid.swift
//  Interface
//
//  Created by Phucnh on 10/5/20.
//

import SwiftUI

struct BookGrid: View {
    
    var models: [Book]
    
    var columns: [GridItem] = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]
    
    // Did select sticker have name 'String'
    var didSelect: ((String) -> Void)?
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, content: {
                ForEach(models) { book in
                    BookCard(model: book)
                        .padding(.bottom, 5)
                        .padding(.trailing, 3)
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
