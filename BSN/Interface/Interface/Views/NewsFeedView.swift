//
//  NewsFeedView.swift
//  Interface
//
//  Created by Phucnh on 9/28/20.
//

import SwiftUI

public struct NewsFeedView: View {
    
    @EnvironmentObject var rootModel: RootViewModel
    
    public init() {
        
    }
    
    public var body: some View {
        VStack {
            // What's on your mind
            HStack() {
                CircleImage(image: rootModel.currentUser.avatar, diameter: 47)
                
                Text("Viết một thảo luận mới")
                    .font(.custom("Roboto-Bold", size: 13))
                
                Spacer()
            }
            .padding(.top, 30)
            .padding(.horizontal)
            
            Separator()
            
            List {
                ForEach(fakeNews) { news in
                    VStack {
                        NewsFeedCard(model: news)
                        Separator()
                    }
                }
                .listRowInsets(.zero)
                .listRowBackground(Color.white)
            }
            //.background(Color.init(hex: 0xECE7E7))
            .onAppear(perform: self.viewDidAppear)
        }
        
    }
    
    func viewDidAppear() {
        print("view appear")
    }
}

struct NewsFeedView_Previews: PreviewProvider {
    static var previews: some View {
        NewsFeedView()
    }
}
