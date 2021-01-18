//
//  ViewFullPhoto.swift
//  Interface
//
//  Created by Phucnh on 9/29/20.
//

import SwiftUI

// Using for present photo of newsfeed card
struct ViewFullPhoto: View {
    
    //var data: Data
    
    //var url: String
    
    var newFeed: NewsFeed
    
    @State var index: Int = 0
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack(alignment: .leading) {
                        
            TabView(selection: $index) {
                ForEach(0..<newFeed.photos.count, id: \.self) { index in
                    ZoomableScrollImage(url: newFeed.photos[index]) {
                        self.dismiss()
                    }
                    .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            
            VStack(alignment: .leading) {
                Spacer()
                
                HStack {
                    CircleImageOptions(image: newFeed.owner.avatar, strokeColor: .white, strokeWidth: 1, diameter: 36, hasShadow: false)
                    
                    VStack(alignment: .leading) {
                        Text(newFeed.owner.displayname)
                            .robotoBold(size: 13)
                            .foregroundColor(.white)
                        
                        CountTimeText(date: newFeed.postTime)
                    }
                }
            }
            .padding()
        }
    }
    
    private func dismiss() {
        withAnimation {
            presentationMode.wrappedValue.dismiss()
        }
    }
}

struct ViewFullPhoto_Previews: PreviewProvider {
    static var previews: some View {
        ViewFullPhoto(newFeed: NewsFeed())
    }
}
