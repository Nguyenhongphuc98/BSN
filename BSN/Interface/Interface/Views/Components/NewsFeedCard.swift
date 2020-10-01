//
//  NewsFeedView.swift
//  Interface
//
//  Created by Phucnh on 9/28/20.
//

import SwiftUI

struct NewsFeedCard: View {
    
    @ObservedObject var model: NewsFeed
    
    @State private var action: Int? = 0
    
    var isDetail: Bool = false
    
    var didTapPhoto: (() -> Void)?
    
    var body: some View {
        VStack {
//            NavigationLink(destination: PostDetailView(post: model), tag: 1, selection: $action) {
//                EmptyView()
//            }
            NavigationLink(destination: PostDetailView(postID: "HEHE"), tag: 1, selection: $action) {
                EmptyView()
            }
            .frame(width: 0, height: 0)
            .opacity(0)
            
            // Header
            HStack {
                CircleImage(image: model.owner.avatar, diameter: 30)
                
                VStack(alignment: .leading) {
                    Text(model.owner.displayname)
                        .font(.custom("Roboto-Bold", size: 13))
                    
                    CountTimeText(date: model.postTime)
                }
                
                Text(model.category.rawValue)
                    .font(.custom("Roboto-Bold", size: 9))
                    .foregroundColor(.white)
                    .padding(.horizontal)
                    .padding(.vertical, 2)
                    .background(RoundedRectangle(cornerRadius: 9).fill(Color.init(hex: 0x59C3FF)))
                    .padding(.top, 3)
                    .padding(.bottom)
                
                Spacer()
                
                // More button
                StickyImageButton(normal: "ellipsis",
                                  active: "ellipsis.rectangle.fill",
                                  color: .black) { (isHeart) in
                    print("did request more: \(isHeart)")
                }
                .padding(.bottom)
            }
            
            // Quote
            if model.quote != nil {
                Text("\"\(model.quote!)\"")
                    .font(.custom("Roboto-MediumItalic", size: 12))
                    .multilineTextAlignment(.center)
                    .padding(3)
            }
            
            // Content
            Text(model.content)
                .font(.custom("Roboto-Light", size: 13))
                .fixedSize(horizontal: false, vertical: false)
                .padding(2)
            
            // Photo
            if model.photo != nil {
                Image(model.photo!, bundle: interfaceBundle)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxHeight: 200)
                    .onTapGesture {
                        self.didTapPhoto?()
                    }
                    .clipped()
                    .padding(2)
            }
            
            actionComponent
        }
        .padding()
        .background(Color.white)
    }
    
    private var actionComponent: some View {
        // Interactive
        HStack {
            // Heart
            StickyImageButton(normal: "heart",
                              active: "heart.fill",
                              color: .init(hex: 0xea299a)) { (isHeart) in
                print("did request heart: \(isHeart)")
            }
            
            Text(model.numHeart.description)
                .font(.custom("Roboto-Bold", size: 13))
            
            // Break heart
            StickyImageButton(normal: "bolt.heart",
                              active: "bolt.heart.fill",
                              color: .init(hex: 0x34495e)) { (isHeartBreak) in
                print("did request heart: \(isHeartBreak)")
            }
            
            Text(model.numBeakHeart.description)
                .font(.custom("Roboto-Bold", size: 13))
            
            // Comment
            StickyImageButton(normal: "bubble.left",
                              active: "bubble.left.fill",
                              color: .black) { (isComment) in
                print("did request comment: \(isComment)")
                action = 1
            }
            .disabled(isDetail)
            
            Text(model.numComment.description)
                .font(.custom("Roboto-Bold", size: 13))
            
            Spacer()
        }
    }
}

struct NewsFeedCard_Previews: PreviewProvider {
    static var previews: some View {
        NewsFeedCard(model: NewsFeed())
    }
}
