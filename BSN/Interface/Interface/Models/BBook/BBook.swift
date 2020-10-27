//
//  BBook.swift
//  Interface
//
//  Created by Phucnh on 10/27/20.
//

import SwiftUI

class BBook: ObservableObject, Identifiable {
    
    var id: String?
    
    //var isbn: String
    
    var title: String
    
    var author: String
    
    var cover: String?
    
    var description: String?
    
    init(id: String?, title: String, author: String, cover: String? = nil, description: String? = nil) {
        self.id = id
        self.title = title
        self.author = author
        self.cover = cover
        self.description = description
    }
    
    init() {
        self.title = "Bứt phá để thành công"
        self.author = "Ks. Nguyễn Hồng Phúc"
        self.cover = ""
        self.description = "Đây là cốn sách nói về cuộc sống của 1 chàng trai xuất thân từ gia đình rất khó khăn, nhưng thông qua đó anh lại nhận ra được nhiều giá trị tự cuộc sống."
    }
}
