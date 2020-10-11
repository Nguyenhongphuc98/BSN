//
//  BookGrid.swift
//  Interface
//
//  Created by Phucnh on 10/5/20.
//

import SwiftUI

struct BookGrid: View {
    
    var models: [Book]
    
    var hasFooter: Bool = false
    
    var isOwner: Bool = false
    
    var columns: [GridItem] = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]
    
    // Did select book have name 'Book'
    var didSelect: ((Book) -> Void)?
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, content: {
                ForEach(models) { book in
                    VStack {
                        BookCard(model: book, navToMyBook: isOwner)
                            .padding(.bottom, 5)
                            .padding(.trailing, 3)
                        
                        if hasFooter {
                            footer
                        }
                    }
                    .padding(.bottom)
                }
            })
        }
        .padding(.horizontal)
        .background(Color.white)
    }
    
    var footer: some View {
        Group {
            if isOwner {
                Button(action: {
                    print("did click exchange book")
                }, label: {
                    NavigationLink(
                        destination: SearchAddBookView(justSearchInStore: true),
                        label: {
                            Text(" Đổi sách  ")
                        })
                })
                .buttonStyle(BaseButtonStyle(size: .mediumH))
            } else {
                Button(action: {
                    print("did click borrow book")
                }, label: {
                    Text("Mượn sách")
                })
                .buttonStyle(BaseButtonStyle(size: .mediumH))
            }
        }
    }
}

struct BookGrid_Previews: PreviewProvider {
    static var previews: some View {
        BookGrid(models: [Book(), Book(), Book(), Book()])
    }
}
