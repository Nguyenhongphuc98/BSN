//
//  HistoryCard.swift
//  Interface
//
//  Created by Phucnh on 12/17/20.
//

import SwiftUI

struct HistoryCard: View {
    
    @StateObject var model: History
    
    var body: some View {
        HStack {
            VStack {
                Image(systemName: model.style.icon())
                    .font(.system(size: 25))
                    .foregroundColor(.white)
                Text(model.style.des())
                    .font(.system(size: 12))
                    .bold()
                    .foregroundColor(.white)
            }
            .padding(.vertical)
            .frame(width: 60)
            .background(model.style.color())
            .clipShape(RoundedRectangle(cornerRadius: 10))
            
            VStack(alignment: .leading) {
                Text(model.bookTitle).lineLimit(2)
                Text("Bạn đọc: \(model.partnerName)")
                CountTimeText(date: model.time)
            }
            .font(.system(size: 14))
            .padding(5)
            
            Spacer()
                        
            if model.style == .new {
                Button(action: {
                    model.cancelRequest()
                }, label: {
                    Text("Xoá")
                })
                .buttonStyle(BaseButtonStyle())
                .padding(5)
            }

            if model.style == .uwaiting {
                Button(action: {
                    model.cancelRequest()
                }, label: {
                    Text("Huỷ")                        
                })
                .buttonStyle(BaseButtonStyle())
                .padding(5)
            }
        }
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding(5)
        .padding(.horizontal)
    }
}
