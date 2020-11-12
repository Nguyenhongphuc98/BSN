//
//  BExchangeBookCard.swift
//  Interface
//
//  Created by Phucnh on 10/27/20.
//

import SwiftUI

struct BExchangeBookCard: View {
    
    var model: BExchangeBook
    
    @State private var nav: Bool = false
    
    @EnvironmentObject var viewModel: ExploreBookViewModel
    
    var body: some View {
        ZStack {
            NavigationLink(
                destination: ExchangeBookView(ebID: model.id!).environmentObject(viewModel),
                isActive: $nav,
                label: {
                    EmptyView()
                })
                .frame(width: 0, height: 0)
                .opacity(0)

            Button {
                nav = true
            } label: {
                HStack(alignment: .center) {
                    BSNImage(urlString: model.needChangeBook.cover!, tempImage: "book_cover")
                        .frame(width: 110, height: 130)

                    VStack(alignment: .leading) {
                        Text(model.needChangeBook.title)
                            .roboto(size: 15)
                            .lineLimit(1)

                        Text(model.needChangeBook.author)
                            .robotoLight(size: 14)
                            .lineLimit(1)

                        Spacer()

                        HStack {
                            Image(systemName: "repeat")
                                .foregroundColor(._primary)
                                .padding(.horizontal)

                            DistanceText(distance: model.distance, style: .short)
                        }

                        Spacer()

                        Text(model.wantChangeBook!.title)
                            .roboto(size: 15)
                            .lineLimit(1)

                        Text(model.wantChangeBook!.author)
                            .robotoLight(size: 14)
                            .lineLimit(1)
                    }

                    Spacer()
                }
            }
        }
        .padding(.vertical)
        .padding(.trailing)
        .background(Color.init(hex: 0xF9F9F9))
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.25), radius: 4, x: 2, y: 2)
        .padding(.horizontal)
    }
}

struct BExchangeBookCard_Previews: PreviewProvider {
    static var previews: some View {
        BExchangeBookCard(model: BExchangeBook())
    }
}
