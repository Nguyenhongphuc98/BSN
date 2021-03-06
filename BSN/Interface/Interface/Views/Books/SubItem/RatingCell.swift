//
//  RatingItem.swift
//  Interface
//
//  Created by Phucnh on 10/5/20.
//

import SwiftUI

// Rating -review bottom of book detail
struct RatingCell: View {
    
    var model: Rating
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                CircleImage(image: model.authorPhoto, diameter: 36)
                
                VStack(alignment: .leading) {
                    HStack {
                        Text(model.title)
                            .robotoBold(size: 15)
                        
                        CountTimeText(date: model.createDate)
                        
                        Spacer()
                    }
                    
                    StarRating(rating: model.avgRating)
                }
            }
            
            Text(model.content)
                .robotoLight(size: 15)
                .padding(.leading)
        }
    }
}

struct RatingItem_Previews: PreviewProvider {
    static var previews: some View {
        RatingCell(model: Rating())
    }
}
