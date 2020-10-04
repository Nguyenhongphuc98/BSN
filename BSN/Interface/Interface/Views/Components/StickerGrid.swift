//
//  BaseGrid.swift
//  Interface
//
//  Created by Phucnh on 10/4/20.
//

import SwiftUI

struct StickerGrid: View {
    
    var columns: [GridItem] = [
        GridItem(.flexible(), spacing: 15),
        GridItem(.flexible(), spacing: 15),
        GridItem(.flexible(), spacing: 15)
    ]
    
    // Did select sticker have name 'String'
    var didSelect: ((String) -> Void)?
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, content: {
                ForEach(stickers,id: \.self) { sticker in
                    Image(sticker, bundle: interfaceBundle)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .onTapGesture(perform: {
                            didSelect?(sticker)
                        })
                }
            })
        }
        .padding(.horizontal)
        .background(Color.white)
    }
}

struct BaseGrid_Previews: PreviewProvider {
    static var previews: some View {
        StickerGrid()
    }
}
