//
//  NewsFeedView.swift
//  Interface
//
//  Created by Phucnh on 9/28/20.
//

import SwiftUI

struct NewsFeedCard: View {
    
    @ObservedObject var model: NewsFeed
    
    @State private var presentPhoto: Bool = false
    
    var isDetail: Bool = false
    
    var didRequestGoToDetail: (() -> Void)?
    var didRequestGoToProfile: (() -> Void)?
    
    var body: some View {
        VStack(alignment: .leading) {
            // Header
            HStack {
                avatar
                
                VStack(alignment: .leading) {
                    Text(model.owner.displayname)
                        .font(.custom("Roboto-Bold", size: 13))
                    
                    CountTimeText(date: model.postTime)
                }
                
                Text(model.category.name)
                    .font(.custom("Roboto-Bold", size: 9))
                    .foregroundColor(.white)
                    .padding(.horizontal)
                    .padding(.vertical, 2)
                    .background(RoundedRectangle(cornerRadius: 9).fill(Color.init(hex: 0x59C3FF)))
                    .padding(.top, 3)
                    .padding(.bottom)
                
                Spacer()
            }
            
            // Quote
            HStack {
                Spacer()
                if model.quote != nil {
                    Text("\"\(model.quote!)\"")
                        .font(.custom("Roboto-MediumItalic", size: 12))
                        .multilineTextAlignment(.center)
                        .padding(3)
                }
                Spacer()
            }
            // Content
            Text(model.content)
                .font(.custom("Roboto-Light", size: 13))
                .fixedSize(horizontal: false, vertical: false)
                .padding(2)
            
            NewsPhotosGrid(photos: model.photos)
            
            actionComponent
        }
        .padding()
        .background(Color.white)
        .fullScreenCover(isPresented: $presentPhoto) {
            ViewFullPhoto(newFeed: model)
        }
    }
    
    private var avatar: some View {
        Button {
            //isShowProfile = true
            didRequestGoToProfile?()
        } label: {
            CircleImage(image: model.owner.avatar, diameter: 30)
        }
        .buttonStyle(BorderlessButtonStyle())
    }
    
    private var actionComponent: some View {
        // Interactive
        HStack {
            // Heart
            StickyImageButton(normal: "heart",
                              active: "heart.fill",
                              color: .init(hex: 0xea299a),
                              isActive: $model.activeHeart) { (isHeart) in
                
                print("did request heart: \(isHeart)")
                model.processReact(action: isHeart ? .heart : .unHeart)
            }
            
            Text(model.numHeart.description)
                .font(.custom("Roboto-Bold", size: 13))
            
            // Break heart
            StickyImageButton(normal: "bolt.heart",
                              active: "bolt.heart.fill",
                              color: .init(hex: 0x34495e),
                              isActive: $model.activeBHeart) { (isHeartBreak) in
                
                print("did request heart: \(isHeartBreak)")
                model.processReact(action: isHeartBreak ? .bHeart : .unBHeart)
            }
            
            Text(model.numBeakHeart.description)
                .font(.custom("Roboto-Bold", size: 13))
            
            // Comment
            StickyImageButton(normal: "bubble.left",
                              active: "bubble.left.fill",
                              color: .black,
                              isActive: $model.activeComment) { (isComment) in
                print("did request comment: \(isComment)")
                didRequestGoToDetail?()
                //action = 1
            }
            .disabled(isDetail)
            
            Text(model.numComment.description)
                .font(.custom("Roboto-Bold", size: 13))
            
            Spacer()
        }
    }
    
    private var tapableImageArea: some View {
        VStack {
            Rectangle()
                .fill(Color.black.opacity(0.0001))
                .onTapGesture {
                    self.presentPhoto.toggle()
                }

            Rectangle()
                .frame(height: 10)
        }
        .foregroundColor(.clear)
    }
}

struct NewsFeedCard_Previews: PreviewProvider {
    static var previews: some View {
        NewsFeedCard(model: NewsFeed())
    }
}

struct NewsPhotosGrid: View {
    
    var photos: [String]
    
    var columns: [GridItem] = [
        GridItem(.adaptive(minimum: 150), spacing: 5)
    ]

    var body: some View {
        if photos.count == 1 {
            BSNImage(urlString: photos[0], tempImage: "unavailable")
                .frame(maxHeight: 200)
                .clipped()
                .padding(2)
        } else {
            LazyVGrid(columns: columns, content: {
                ForEach(photos, id: \.self) { photo in
                    BSNImage(urlString: photo, tempImage: "unavailable")
                        .clipped()
                        .padding(2)
                }
            })
        }
    }
}
