//
//  Segment.swift
//  Interface
//
//  Created by Phucnh on 10/5/20.
//

import SwiftUI

struct Segment: View {
    
    var tabNames: [String]
    
    @Binding var focusIndex: Int
    
    var body: some View {
        HStack(spacing: 0){
            ForEach(0..<tabNames.count) { index in
                Text(tabNames[index])
                    .font(.system(size: 14))
                    .foregroundColor(self.focusIndex == index ? .white : Color._primary)
                    .fontWeight(.bold)
                    
                    .padding(.vertical,10)
                    .padding(.horizontal)
                    .background(Color._primary.opacity(self.focusIndex == index ? 1 : 0))
                    .clipShape(Capsule())
                    .onTapGesture {
                        
                        withAnimation(.default){
                            
                            self.focusIndex = index
                        }
                    }
            }
        }
        .background(Color.black.opacity(0.06))
        .clipShape(Capsule())
        .padding(.horizontal)
    }
}

struct Segment_Previews: PreviewProvider {
    
    @State static var index: Int = 0
    
    static var previews: some View {
        Segment(tabNames: ["index1", "index2"], focusIndex: $index)
    }
}
