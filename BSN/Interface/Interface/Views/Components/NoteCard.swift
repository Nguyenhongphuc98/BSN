//
//  NoteCard.swift
//  Interface
//
//  Created by Phucnh on 10/10/20.
//

import SwiftUI

struct NoteCard: View {
    
    var model: Note
    
    @State private var showingViewFull: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text(model.page ?? "*")
                    .pridi(size: 18)
                    .frame(width: 30, height: 30)
                    .foregroundColor(.white)
                    .background(Color.init(hex: 0x52BA13))
                    .clipShape(Circle())
                
                Text(model.createDate.getDateStr(format: "MMM d, yyyy"))
                    .robotoBold(size: 17)
                    .foregroundColor(._primary)
                Spacer()
            }
                
            Text(model.content)
                .pridi(size: 16)
            
            if let url = model.photoUrl, !url.isEmpty {
                Button(action: {
                    self.showingViewFull.toggle()
                }, label: {
                    BSNImage(urlString: url, tempImage: "unavailable")
                        .frame(maxHeight: 150)
                        .clipped()
                        .padding(2)
                })
                   .fullScreenCover(isPresented: $showingViewFull) {
                    ZoomableScrollImage(url: model.photoUrl) {
                            self.showingViewFull.toggle()
                        }
                    }
            }
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
