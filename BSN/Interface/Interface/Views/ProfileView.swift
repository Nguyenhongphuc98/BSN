//
//  Profile.swift
//  BSN
//
//  Created by Phucnh on 9/23/20.
//

import SwiftUI

public struct ProfileView: View {
    
    @ObservedObject var viewModel: ProfileViewModel = ProfileViewModel.shared

    @State var showPosts: Bool = true
    
    @EnvironmentObject var root: AppManager
    
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
                            .pattaya(size: 18)
                        
                        HStack {
                            Image(systemName: "mappin.and.ellipse")
                            
                            Text(viewModel.profile.location)
                                .robotoLight(size: 13)
                                
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
                    .robotoLightItalic(size: 13)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                // Action button
                HStack {
                    BButton(isActive: $showPosts) {
                        Text("Bài viết")
                            .robotoBold(size: 18)
                    }

                    BButton(isActive: $showPosts, invert: true) {
                        Text("Tủ sách")
                            .robotoBold(size: 18)
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
        .onAppear(perform: viewAppeared)
    }
    
    func viewAppeared() {
        if root.selectedIndex == RootIndex.profile.rawValue {
            root.navBarTitle = "Trang cá nhân"
            root.navBarHidden = true
        }
        print("profile-apeard")
    }
}

#if DEBUG
struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
#endif
