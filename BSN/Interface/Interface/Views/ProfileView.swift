//
//  Profile.swift
//  BSN
//
//  Created by Phucnh on 9/23/20.
//

import SwiftUI
import Component

public struct ProfileView: View {
    
    @ObservedObject var viewModel: ProfileViewModel = ProfileViewModel.shared

    @State var showPosts: Bool = true
    
    public init() { }
        public var body: some View {
        ZStack(alignment: .leading) {
            VStack {
                // Cover
                Image(viewModel.profile.cover, bundle: interfaceBundle)
                    .resizable()
                    .aspectRatio(contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
                    .frame(height: 200)
                    .clipped()
                
                // Name and description
                HStack {
                    VStack(alignment: .leading) {
                        Text(viewModel.profile.user.displayname)
                            .font(.custom("Pattaya-Regular", size: 18))
                        
                        HStack {
                            Image(systemName: "mappin.and.ellipse")
                            
                            Text(viewModel.profile.location)
                                .font(.custom("Roboto-Light", size: 13))
                                
                        }
                        
                        Rectangle()
                            .fill(Color.gray)
                            .frame(width: 50, height: 2)
                            .padding(.vertical)
                    }
                    .padding(.top)
                    .padding(.horizontal)
                    
                    Spacer()
                }
                
                Text(viewModel.profile.description)
                    .font(.custom("Roboto-LightItalic", size: 13))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                // Action button
                HStack {
                    BButton(isActive: $showPosts) {
                        Text("Bài viết")
                            .font(.custom("Roboto-Bold", size: 18))
                    }

                    BButton(isActive: $showPosts, invert: true) {
                        Text("Tủ sách")
                            .font(.custom("Roboto-Bold", size: 18))
                    }
                }
                .padding()
                
                Spacer()
            }
            
            // Avatar
            VStack() {
                CircleImageOptions(image: viewModel.profile.user.avatar, diameter: 80)
                    .padding(.top, 135)
                    .padding(.leading)
                
                Spacer()
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

#if DEBUG
struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
#endif
