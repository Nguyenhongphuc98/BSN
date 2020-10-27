//
//  BBookGrid.swift
//  Interface
//
//  Created by Phucnh on 10/27/20.
//

import SwiftUI

enum BookGridItemStyle {
    case mybook
    case suggestbook
}

struct BBookGrid: View {
    
    var models: [BBook]
    
    var style: BookGridItemStyle
    
    var columns: [GridItem] = [
        GridItem(.flexible(), spacing: 0),
        GridItem(.flexible(), spacing: 0)
    ]
    
    // Did select book have name 'Book'
    var didSelect: ((Book) -> Void)?
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, content: {
                ForEach(models) { book in
                    if style == .mybook {
                        BUserBookCard(model: book as! BUserBook)
                    } else {
                        SuggestBookCard(model: book as! BSusggestBook)
                    }
                }
            })
        }
        .padding(.horizontal, 10)
        .background(Color.white)
    }
}

struct BBookGrid_Previews: PreviewProvider {
    static var previews: some View {
        BBookGrid(models: [BSusggestBook(), BSusggestBook()], style: .suggestbook)
    }
}
