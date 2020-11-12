//
//  Profile.swift
//  BSN
//
//  Created by Phucnh on 9/23/20.
//

import SwiftUI

public struct ProfileView: View, PopToable {
    
    var viewName: ViewName = .profileRoot
    
    @EnvironmentObject var navState: NavigationState
    
    // =========================
    
    @ObservedObject var viewModel: ProfileViewModel = ProfileViewModel.shared

    @State private var selectedSegment: Int = 0
    
    @EnvironmentObject var root: AppManager
    
    /// User will display on profile
    // If value is nil, get current userinfo
    var userID: String?
    
    @State private var navAddUB: Bool = false
    
    public init(uid: String? = nil) {
        self.userID = uid
    }
    
    public var body: some View {
        ZStack {
            ScrollView {
                ScrollViewReader { value in
                    VStack {
                        ZStack(alignment: .topLeading) {
                            userInfo
                            
                            // Avatar
                            VStack() {
                                CircleImageOptions(image: viewModel.profile.user.avatar, diameter: 80)
                                    .padding(.top, 115)
                                    .padding(.leading)
                                
                                Spacer()
                            }
                            
                            HStack {
                                Spacer()
                                NavigationLink(
                                    destination: SettingView(),
                                    label: {
                                        Image(systemName: "gearshape.fill")
                                            .font(.system(size: 20))
                                            .padding(10)
                                            .background(Color.init(hex: 0xEFEFEF))
                                            .cornerRadius(25)
                                            .shadow(radius: 3)
                                    })
                                    .padding()
                            }
                        }
                        
                        dinamicContent(proxy: value)
                            .frame(height: UIScreen.screenHeight)
                    }
                }
            }
            
            if viewModel.isLoading {
                Loading()
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
                .aspectRatio(contentMode: .fill)
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
            BBookGrid(models: viewModel.books, style: .mybook)
                .padding(.bottom, 100)
            
            NavigationLink(
                destination: SearchAddBookView()
                    .environmentObject(navState)
                    .environmentObject(PassthroughtEB(userBook: BUserBook())), // just temp
                isActive: $navAddUB,
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
        .onReceive(navState.$viewName) { (viewName) in
            if viewName == self.viewName {
                navAddUB = false
                // reload data when pop to root (this view)
                viewModel.prepareData(uid: userID)
            }
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
    
    private func viewAppeared() {
        viewModel.prepareData(uid: userID)
    }
}

#if DEBUG
struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
#endif
