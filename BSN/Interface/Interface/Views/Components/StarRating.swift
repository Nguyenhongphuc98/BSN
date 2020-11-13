//
//  StarRating.swift
//  Interface
//
//  Created by Phucnh on 10/5/20.
//

import SwiftUI

struct StarRating: View {
    
    var rating: Float
    
    var total: Int = 5
    
    var body: some View {
        HStack(spacing: 3) {
            ForEach(0..<rating.div) { _ in
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
            }
            
            if rating.remain != Float.zero {
                Image(systemName: "star.leadinghalf.fill")
                    .foregroundColor(.yellow)
            }
            
            ForEach(0..<rating.lastStar(total: total)) { _ in
                Image(systemName: "star")
                    .foregroundColor(.gray)
            }
        }
        .font(.system(size: 12))
    }
}

struct StarRating_Previews: PreviewProvider {
    static var previews: some View {
        StarRating(rating: 3)
    }
}
