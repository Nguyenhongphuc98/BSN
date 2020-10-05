//
//  ExchangeBook.swift
//  Interface
//
//  Created by Phucnh on 10/5/20.
//

import SwiftUI

class ExchangeBook: Identifiable {
    
    var photo: String
    
    var title: String
    
    var author: String
    
    var exchangeBookTitle: String
    
    var exchangeBookAuthor: String
    
    init() {
        photo = "book"
        title = "Bứt phá để thành công"
        author = "TS. Mai Thế Trung"
        exchangeBookTitle = "Sắc màu cuộc sống"
        exchangeBookAuthor = "ThS. Kỹ Văn Minh"
    }
}
