//
//  BookStateText.swift
//  Interface
//
//  Created by Phucnh on 10/10/20.
//

import SwiftUI

struct BookStateText: View {
    
    var state: BookState
    
    var body: some View {
        HStack {
            Text("Trạng thái sách: ")
                .robotoLight(size: 13)
            +
            Text(getTitle())
                .robotoBold(size: 13)
                .foregroundColor(._primary)
        }
    }
    
    func getTitle() -> String {
        switch state {
        case .available:
            return "Sẵn sàng cho mượn"
        case .borrowed:
            return "Đang cho mượn"
        case .reading:
            return "Đang đọc"
        case .exchanged:
            return "Đã trao đổi"
        case .unknown:
            return "Không xác định"
        }
    }
}

struct BookStateText_Previews: PreviewProvider {
    static var previews: some View {
        BookStateText(state: .available)
    }
}
