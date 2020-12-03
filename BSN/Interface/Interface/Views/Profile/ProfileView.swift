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
    
    //@EnvironmentObject var viewModel: ProfileViewModel
    @StateObject var viewModel: ProfileViewModel

    @State private var selectedSegment: Int = 0
    
    @EnvironmentObject var root: AppManager
    
    /// User will display on profile
    // If value is nil, get current userinfo
    var userID: String?
    
    @State private var navAddUB: Bool = false
    
    // Handle nav post detail
    @State private var isShowPostDetail: Bool = false
    @ObservedObject private var selectedNews: NewsFeed = NewsFeed()
    
    public init(uid: String? = nil, vm: ProfileViewModel) {
        self.userID = uid
        self._viewModel = StateObject(wrappedValue: vm)
    }
    
    public var body: some View {
        ZStack {
            navToPostDetailLabel
            
            ScrollView {
                ScrollViewReader { value in
                    VStack {
                        ZStack(alignment: .topLeading) {
                            userInfo
                            
                            // Avatar
                            VStack() {
                                CircleImageOptions(image: viewModel.user.avatar, diameter: 80)
                                    .id(viewModel.user.avatar ?? UUID().uuidString)
                                    .padding(.top, 115)
                                    .padding(.leading)
                                
                                Spacer()
                            }
                            
                            if userID == nil {
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
                        }
                        
                        dinamicContent(proxy: value)
                    }
                }
            }
            
            if viewModel.isLoading {
                Loading()
            }
        }
        .navigationBarTitle(Text("Trang cá nhân"), displayMode: .inline)
        .onAppear(perform: viewAppeared)
    }
    
    var userInfo: some View {
        VStack {
            // Cover
            BSNImage(urlString: viewModel.user.cover, tempImage: "cover")                
                .frame(width: UIScreen.screenWidth ,height: 180)
                .clipped()
            
            // Name and description
            HStack {
                VStack(alignment: .leading) {
                    HStack {
                        Text(viewModel.user.displayname)
                            .pattaya(size: 18)
                        Spacer()
                        if userID != nil {
                            // Viewing profile other user
                            Button {
                                viewModel.processFollow()
                            } label: {
                                Image(systemName: "heart.circle")
                                    .font(.system(size: 22))
                                    .foregroundColor(foregroundFollowBtn)
                            }
                        }
                    }
                    
                    HStack {
                        Image(systemName: "mappin.and.ellipse")
                        
                        Text(viewModel.user.locationText)
                            .robotoLight(size: 13)
                            
                    }
                    .padding()
                    
                    Rectangle()
                        .fill(Color.gray)
                        .frame(width: 50, height: 2)
                }
                .padding(.top)
                .padding(.horizontal)
                
                Spacer()
            }
            
            Text(viewModel.user.about)
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
                    NewsFeedCard(
                        model: p,
                        didRequestGoToDetail: {
                            selectedNews.clone(from: p)
                            isShowPostDetail = true
                        }
                    )
                        .id(UUID())
                    Separator()
                }
            }
            .listRowInsets(.zero)
        }
        .padding(.bottom)
    }
    
    var books: some View {
        ZStack(alignment: .trailing) {
            BBookGrid(models: viewModel.books, style: .mybook)
                .padding(.bottom)
            
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
    
    var foregroundFollowBtn: Color {
        viewModel.followed ? .blue : .gray
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
        .frame(height: UIScreen.screenHeight - 100)
    }
    
    private var navToPostDetailLabel: some View {
        NavigationLink(
            destination: PostDetailView(post: selectedNews, didReact: { (post) in
                
            }),
            isActive: $isShowPostDetail
        ) {
            EmptyView()
        }
        .frame(width: 0, height: 0)
        .opacity(0)
    }
    
    private func viewAppeared() {
        viewModel.prepareData(uid: userID)
        print("Profile Didappeared")
    }
}

#if DEBUG
struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(vm: ProfileViewModel())
    }
}
#endif
