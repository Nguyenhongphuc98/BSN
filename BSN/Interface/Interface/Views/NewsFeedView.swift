//
//  NewsFeedView.swift
//  Interface
//
//  Created by Phucnh on 9/28/20.
//

import SwiftUI

public struct NewsFeedView: View {
    
    public init() {
        
    }
    
    public var body: some View {
        VStack {
            NewsFeedCard(model: NewsFeed())
            NewsFeedCard(model: NewsFeed())
            NewsFeedCard(model: NewsFeed())
        }
        .background(Color.init(hex: 0xECE7E7))
    }
}

struct NewsFeedView_Previews: PreviewProvider {
    static var previews: some View {
        NewsFeedView()
    }
}
