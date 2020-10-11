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
                Text(state.getTitle())
                .robotoBold(size: 13)
                .foregroundColor(._primary)
        }
    }
}

struct BookStateText_Previews: PreviewProvider {
    static var previews: some View {
        BookStateText(state: .available)
    }
}
