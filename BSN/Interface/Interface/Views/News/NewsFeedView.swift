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
  
    public init() {
        
    }
    
    public var body: some View {
        
        VStack {
            editor
            
            Separator()
            
            // News feed
            List {
                ForEach(viewModel.newsData) { news in
                    VStack {
                        ZStack(alignment: .topTrailing) {
                            
                            NewsFeedCard(model: news)
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
    
            // Loading view
            if viewModel.isLoading {
                Loading()
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
    
    func viewDidAppear() {
        print("news-appeard")
    }
}

struct NewsFeedView_Previews: PreviewProvider {
    static var previews: some View {
        NewsFeedView()
    }
}
