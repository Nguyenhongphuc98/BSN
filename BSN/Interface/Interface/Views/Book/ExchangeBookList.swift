//
//  ExchangeBookList.swift
//  Interface
//
//  Created by Phucnh on 10/5/20.
//

import SwiftUI

struct ExchangeBookList: View {
    
    var models: [ExchangeBook]
    
    var body: some View {
        VStack {
            Separator(color: .white, height: 3)
            
            List {
                ForEach(models) { item in
                    VStack {
                        ExchangeBookCard(model: item)
                        Separator(color: .white, height: 3)
                    }
                }
                .listRowInsets(.zero)
            }
        }
    }
}

struct ExchangeBookList_Previews: PreviewProvider {
    static var previews: some View {
        ExchangeBookList(models: [ExchangeBook(), ExchangeBook()])
    }
}
