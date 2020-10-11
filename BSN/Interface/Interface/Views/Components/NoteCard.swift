//
//  NoteCard.swift
//  Interface
//
//  Created by Phucnh on 10/10/20.
//

import SwiftUI

struct NoteCard: View {
    
    var model: Note
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text(model.createDate.getDate(format: "MMM d, yyyy"))
                    .robotoBold(size: 17)
                    .foregroundColor(._primary)
                Spacer()
            }
                
            Text(model.content)
        }
        .padding()
        .background(Color.init(hex: 0xF2F8FB))
        .cornerRadius(20)
        .shadow(radius: 5)
    }
}

struct NoteCard_Previews: PreviewProvider {
    static var previews: some View {
        NoteCard(model: Note())
    }
}
