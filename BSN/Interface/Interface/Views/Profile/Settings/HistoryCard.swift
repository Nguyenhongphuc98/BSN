//
//  HistoryCard.swift
//  Interface
//
//  Created by Phucnh on 12/17/20.
//

import SwiftUI

struct HistoryCard: View {
    
    var model: History
    
    var body: some View {
        HStack {
            VStack {
                Image(systemName: model.type.icon())
                    .font(.system(size: 25))
                    .foregroundColor(.white)
                Text(model.type.des())
                    .font(.system(size: 12))
                    .bold()
                    .foregroundColor(.white)
            }
            .padding(.vertical)
            .frame(width: 60)
            .background(model.type.color())
            .clipShape(RoundedRectangle(cornerRadius: 10))
            
            VStack(alignment: .leading) {
                Text(model.bookTitle)
                Text("Bạn đọc: \(model.partnerName)")
                Text("time")
            }
            .font(.system(size: 14))
            .padding(5)
            
            Spacer()
                        
            if model.type == .new {
                Button(action: {

                }, label: {
                    Text("Xoá")
                        .foregroundColor(.red)
                        .padding()
                })
            }

            if model.type == .uwaiting {
                Button(action: {

                }, label: {
                    Text("Huỷ")
                        .foregroundColor(.blue)
                        .padding()
                })
            }
        }
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding(5)
    }
}
