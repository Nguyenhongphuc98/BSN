//
//  NewsFeedView.swift
//  Interface
//
//  Created by Phucnh on 9/28/20.
//

import SwiftUI

public struct NewsFeedView: View {
    
    @EnvironmentObject var root: AppManager
    
    @StateObject var viewModel: NewsFeedViewModel = NewsFeedViewModel.shared
    
    @State private var presentCPV: Bool = false
    
    @State private var isShowPostDetail: Bool = false
    @State private var isShowProfile: Bool = false
    
    @ObservedObject private var selectedNews: NewsFeed = NewsFeed()
    @State private var selectedUserID: String = ""
  
    public init() {
        
    }
    
    public var body: some View {
        VStack {
            navToProfileLabel
            navToPostDetailLabel
            
            editor
            
            Separator()
            
            // News feed
            List {
                ForEach(viewModel.newsData, id: \.self) { news in
                    VStack {
                        ZStack(alignment: .topTrailing) {
                            
                            NewsFeedCard(
                                model: news,
                                didRequestGoToDetail: {
                                    selectedNews.clone(from: news)
                                    isShowPostDetail = true
                                }, didRequestGoToProfile: {
                                    selectedUserID = news.owner.id
                                    isShowProfile = true
                                }
                            )
                            .onAppear(perform: {
                                self.viewModel.loadMoreIfNeeded(item: news)
                            })
                            
                            if news.owner.id == AppManager.shared.currenUID {
                                // More button
                                Menu {
                                    Button {
                                        viewModel.deletePost(pid: news.id)
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
            .listStyle(PlainListStyle())
            .onAppear(perform: self.viewDidAppear)
            .embededLoadingFull(isLoading: $viewModel.isLoading)
    
            if viewModel.isLoadmore {
                CircleLoading(frame: CGSize(width: 20, height: 20))
            }
        }
    }
    
    private var editor: some View {
        // What's on your mind
        HStack() {
            CircleImage(image: root.currentUser.avatar, diameter: 47)
            
            Text("Viết một thảo luận mới")
                .font(.custom("Roboto-Bold", size: 13))
            
            Spacer()
        }
        .padding(.top, 30)
        .padding(.horizontal)
        .onTapGesture {
            self.presentCPV.toggle()
        }
        .fullScreenCover(isPresented: $presentCPV) {
            CreatePostView()
        }
    }
    
    private var navToPostDetailLabel: some View {
        NavigationLink(
            destination: PostDetailView(post: selectedNews, didReact: { (post) in
                viewModel.postDidChange(post: post)
            }),
            isActive: $isShowPostDetail
        ) {
            EmptyView()
        }
        .frame(width: 0, height: 0)
        .opacity(0)
    }
    
    private var navToProfileLabel: some View {
        NavigationLink(
            destination: ProfileView(uid: selectedUserID, vm: ProfileViewModel())
                .environmentObject(NavigationState()),
            isActive: $isShowProfile
        ) {
            EmptyView()
        }
        .frame(width: 0, height: 0)
        .opacity(0)
    }
   
    func viewDidAppear() {
        print("news-appeard")        
    }
}

struct NewsFeedView_Previews: PreviewProvider {
    static var previews: some View {
        NewsFeedView()
    }
}
