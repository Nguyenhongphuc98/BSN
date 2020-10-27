//
//  Profile.swift
//  BSN
//
//  Created by Phucnh on 9/23/20.
//

import SwiftUI

public struct ProfileView: View {
    
    @ObservedObject var viewModel: ProfileViewModel = ProfileViewModel.shared

    @State private var selectedSegment: Int = 0
    
    @EnvironmentObject var root: AppManager
    
    public init() { }
    
    public var body: some View {
        ScrollView {
            ScrollViewReader { value in
                VStack {
                    ZStack(alignment: .leading) {
                        userInfo
                        
                        // Avatar
                        VStack() {
                            CircleImageOptions(image: viewModel.profile.user.avatar, diameter: 80)
                                .padding(.top, 115)
                                .padding(.leading)
                            
                            Spacer()
                        }
                    }
                    
                    dinamicContent(proxy: value)
                        .frame(height: UIScreen.screenHeight)
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear(perform: viewAppeared)
    }
    
    var userInfo: some View {
        VStack {
            // Cover
            Image(viewModel.profile.cover, bundle: interfaceBundle)
                .resizable()
                .aspectRatio(contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
                .frame(height: 180)
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
                }
                .padding(.top)
                .padding(.horizontal)
                
                Spacer()
            }
            
            Text(viewModel.profile.description)
                .robotoLightItalic(size: 13)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .id("des")
                .fixedSize(horizontal: false, vertical: false)
            
            Spacer()
        }
    }
    
    var posts: some View {
        List {
            ForEach(viewModel.posts) { p in
                VStack {
                    NewsFeedCard(model: p)
                    Separator()
                }
            }
            .listRowInsets(.zero)
        }
    }
    
    var books: some View {
        ZStack(alignment: .trailing) {
            //BookGrid(models: viewModel.books, hasFooter: true, isOwner: true)
            
            BBookGrid(models: viewModel.books, style: .mybook)
            
            NavigationLink(
                destination: SearchAddBookView(),
                label: {
                    
                    Image(systemName: "plus")
                        .font(.system(size: 35))
                        .padding(10)
                        .background(Color.init(hex: 0xEFEFEF))
                        .cornerRadius(25)
                        .shadow(radius: 3)
                        .padding()
                })
                .position(x: 50, y: 450)
        }
    }
    
    func dinamicContent(proxy: ScrollViewProxy) -> some View {
        VStack {
            Segment(tabNames: ["   Bài viết   ", "   Tủ sách   "], focusIndex: $selectedSegment) {
                proxy.scrollTo("des", anchor: .top)
            }
                .padding(.vertical, 5)
            
            TabView(selection: self.$selectedSegment) {
                posts
                    .tag(0)
                
                books
                    .tag(1)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        }
    }
    
    func viewAppeared() {
        print("profile-appeard")
    }
}

#if DEBUG
struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
#endif
