//
//  ViewFullPhoto.swift
//  Interface
//
//  Created by Phucnh on 9/29/20.
//

import SwiftUI

struct ViewFullPhoto: View {
    
    //var data: Data
    
    //var url: String
    
    var newFeed: NewsFeed
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack(alignment: .leading) {
            ZoomableScrollImage(url: newFeed.photo!) {
                self.dismiss()
            }
            
            VStack(alignment: .leading) {
                Button(action: {
                    self.dismiss()
                }, label: {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.white)
                })
                
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
        .background(Color.init(hex: 0x565050))
        .edgesIgnoringSafeArea(.all)
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