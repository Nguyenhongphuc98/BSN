//
//  BookStatusText.swift
//  Interface
//
//  Created by Phucnh on 10/6/20.
//

import SwiftUI

struct BookStatusText: View {
    
    var status: BookStatus
    
    var body: some View {
        HStack {
            Text("Tình trạng sách: ")
                .robotoLight(size: 13)
            +
            Text(getTitle())
                .robotoBold(size: 13)
                .foregroundColor(getColor())
        }
    }
    
    func getTitle() -> String {
        switch status {
        case .new:
            return "Mới"
        case .likeNew:
            return "Như mới"
        case .old:
            return "Sách đã cũ"
        case .veryOld:
            return "Sách rất cũ"
        }
    }
    
    func getColor() -> Color {
        switch status {
        case .new:
            return ._primary
        case .likeNew:
            return .init(hex: 0x298DEA)
        case .old:
            return .init(hex: 0x05E744)
        case .veryOld:
            return .init(hex: 0xFF6D1B)
        }
    }
}

struct BookStatusText_Previews: PreviewProvider {
    static var previews: some View {
        BookStatusText(status: .new)
    }
}
