//
//  Profile.swift
//  BSN
//
//  Created by Phucnh on 9/23/20.
//

import SwiftUI

// showing action sheet
enum ActionSheetType {
    case Avatar
    case Cover
}

public struct ProfileView: View, PopToable {
    
    // User will display on profile
    // If value is nil, get current userinfo
    var userID: String?
    var viewName: ViewName = .profileRoot
    
    @EnvironmentObject var navState: NavigationState
    @EnvironmentObject var root: AppManager
    
    //@EnvironmentObject var viewModel: ProfileViewModel
    @StateObject var viewModel: ProfileViewModel

    @State private var selectedSegment: Int = 0
    @State private var navAddUB: Bool = false
    
    // Handle nav post detail
    @State private var isShowPostDetail: Bool = false
    @ObservedObject private var selectedNews: NewsFeed = NewsFeed()
    
    @State private var showingActionSheet: Bool = false
    @State private var typeOfActionSheet: ActionSheetType = .Avatar
    @State private var showingViewFull: Bool = false
    
    // Change cover or photo
    @State var showPhotoPicker: Bool = false
    
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
                            // Can't let all sheet in same level
                            // so break it to child views
                            userInfo
                                .fullScreenCover(isPresented: $showingViewFull) {
                                    ZoomableScrollImage(url: typeOfActionSheet == .Avatar ? viewModel.user.avatar! : viewModel.user.cover!) {
                                        self.showingViewFull.toggle()
                                    }
                                }
                            
                            avatar
                                .sheet(isPresented: $showPhotoPicker) {
                                    ImagePicker(picker: $showPhotoPicker) { img in
                                        //viewModel.photo = data
                                        viewModel.upload(image: img, for: typeOfActionSheet)
                                    }
                                }
                            
                            if userID == nil {
                                settingLabel
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
        .actionSheet(isPresented: $showingActionSheet) {
            ActionSheet(title: Text("Lựa chọn hành động với ảnh"), buttons: actionSheetButton)
        }
        .alert(isPresented: $viewModel.showAlert, content: alert)
    }
    
    private var actionSheetButton: [Alert.Button] {
        if userID == nil {
            // Profile of himself
            return [
                .default(Text("Xem ảnh")) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        showingViewFull.toggle()
                    }
                },
                .default(Text("Cập nhật ảnh mới")) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        showPhotoPicker.toggle()
                    }
                },
                .cancel()
            ]
        } else {
            // Guest
            return [
                .default(Text("Xem ảnh")) { showingViewFull.toggle() },
                .cancel()
            ]
        }
    }
    
    private var userInfo: some View {
        VStack {
            cover
            
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
    
    private var avatar: some View {
        VStack() {
            ZStack {
                CircleImageOptions(image: viewModel.user.avatar, diameter: 80)
                    .id(viewModel.user.avatar ?? UUID().uuidString)
                    .padding(.top, 115)
                    .padding(.leading)
                    .onTapGesture {
                        typeOfActionSheet = .Avatar
                        showingActionSheet = true
                    }
                
                if viewModel.isUploading && typeOfActionSheet == .Avatar {
                    uploadImageProgess
                }
            }
      
            Spacer()
        }
    }
    
    private var cover: some View {
        ZStack {
            BSNImage(urlString: viewModel.user.cover, tempImage: "cover")
                .frame(width: UIScreen.screenWidth ,height: 180)
                .id(viewModel.user.cover ?? UUID().uuidString)
                .clipped()
                .onTapGesture {
                    typeOfActionSheet = .Cover
                    showingActionSheet = true
                }
            
            if viewModel.isUploading && typeOfActionSheet == .Cover {
                uploadImageProgess
            }
        }
    }
    
    private var settingLabel: some View {
        HStack {
            Spacer()
            NavigationLink(
                destination: SettingView(),
                label: {
                    Image(systemName: "ellipsis.circle.fill")
                        .font(.system(size: 20))
                        .padding(10)
                        .background(Color.init(hex: 0xEFEFEF))
                        .cornerRadius(25)
                        .shadow(radius: 3)
                })
                .padding()
        }
    }
    
    private var posts: some View {
        List {
            ForEach(viewModel.posts) { p in
                VStack {
                    ZStack(alignment: .topTrailing) {
                        
                        NewsFeedCard(
                            model: p,
                            didRequestGoToDetail: {
                                selectedNews.clone(from: p)
                                isShowPostDetail = true
                            }
                        ).id(UUID())
                        
                        if p.owner.id == AppManager.shared.currenUID {
                            // More button
                            Menu {
                                Button {
                                    viewModel.deletePost(pid: p.id)
                                } label: {
                                    Text("Xoá bài viết")
                                }
                            }
                            label: {
                                // More button
                                Image(systemName: "ellipsis").padding()
                            }
                        }
                    }
                    
                    Separator()
                }
            }
            .listRowInsets(.zero)
        }
        .padding(.bottom)
    }
    
    private var books: some View {
        ZStack(alignment: .trailing) {
            BBookGrid(models: viewModel.books, style: .mybook)
                .id("bbookgrid")
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
                // If need reload, it will call force func
                // viewModel.prepareData(uid: userID)
            }
        }
    }
    
    private var foregroundFollowBtn: Color {
        viewModel.followed ? .blue : .gray
    }
    
    private func dinamicContent(proxy: ScrollViewProxy) -> some View {
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
    
    private var uploadImageProgess: some View {
        ProgressView(value: viewModel.uploadProgess, total: 1)
            .progressViewStyle(CircularProgressViewStyle())
    }
    
    private func alert() -> Alert {
        return Alert(
            title: Text("Kết quả"),
            message: Text(viewModel.resourceInfo.des()),
            dismissButton: .default(Text("OK"))
        )
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
