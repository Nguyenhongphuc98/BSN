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
            Text("Tình trạng: ")
                .robotoLight(size: 13)
            +
                Text(status.des())
                .robotoBold(size: 13)
                .foregroundColor(status.getColor())
        }
    }
}

struct BookStatusText_Previews: PreviewProvider {
    static var previews: some View {
        BookStatusText(status: .new)
    }
}
