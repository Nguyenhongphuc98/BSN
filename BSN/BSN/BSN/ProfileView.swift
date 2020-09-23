//
//  Profile.swift
//  BSN
//
//  Created by Phucnh on 9/23/20.
//

import SwiftUI
import Interface
import Component

struct ProfileView: View {
    
    @ObservedObject var viewModel: ProfileViewModel = ProfileViewModel.shared
    
    var body: some View {
        ZStack(alignment: .leading) {
            VStack {
                Image(viewModel.profile.cover)
                    .resizable()
                    .frame(height: 200)
                
                HStack {
                    VStack(alignment: .leading) {
                        Text(viewModel.profile.user.displayname)
                            .font(.custom("Pattaya-Regular", size: 25))
                        
                        HStack {
                            Image(systemName: "mappin.and.ellipse")
                            
                            Text(viewModel.profile.location)
                                .font(.custom("Roboto-Light", size: 18))
                                
                        }
                        
                        Rectangle()
                            .fill(Color.gray)
                            .frame(width: 80, height: 3)
                            .padding(.vertical)
                    }
                    .padding()
                    
                    Spacer()
                }
                
                Text(viewModel.profile.description)
                    .font(.custom("Roboto-LightItalic", size: 18))
                
                Spacer()
            }
            
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
