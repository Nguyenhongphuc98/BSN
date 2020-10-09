//
//  ExchangeBook.swift
//  Interface
//
//  Created by Phucnh on 10/5/20.
//

import SwiftUI

// Model in Explore Book, exchange book card
class ExchangeBook: Identifiable {
    
    var photo: String
    
    var title: String
    
    var author: String
    
    var exchangeBookTitle: String
    
    var exchangeBookAuthor: String
    
    var distance: Float
    
    init() {
        photo = "book"
        title = "Bứt phá để thành công"
        author = "TS. Mai Thế Trung"
        exchangeBookTitle = "Sắc màu cuộc sống"
        exchangeBookAuthor = "ThS. Kỹ Văn Minh"
        distance = Float.random(in: 100...2999)
    }
}
