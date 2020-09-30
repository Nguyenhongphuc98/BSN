//
//  NewsFeedView.swift
//  Interface
//
//  Created by Phucnh on 9/28/20.
//

import SwiftUI

public struct NewsFeedView: View {
    
    @EnvironmentObject var rootModel: RootViewModel
    
    @StateObject var viewModel: NewsFeedViewModel = NewsFeedViewModel()
    
    @State private var presentCPV: Bool = false
    
    @State private var presentPhoto: Bool = false
    
    public init() {
        
    }
    
    public var body: some View {
        VStack {
            // What's on your mind
            HStack() {
                CircleImage(image: rootModel.currentUser.avatar, diameter: 47)
                
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
            
            Separator()
            
            // News feed
            List {
                ForEach(fakeNews) { news in
                    VStack {
                        NewsFeedCard(model: news, didTapPhoto: {
                            self.viewModel.selectedNews = news
                            presentPhoto.toggle()
                        })
                            .onAppear(perform: {
                                self.viewModel.loadMoreIfNeeded(item: news)
                            })
                        
                        Separator()
                    }
                }
                .listRowInsets(.zero)
            }
            .onAppear(perform: self.viewDidAppear)
            .fullScreenCover(isPresented: $presentPhoto) {
                ViewFullPhoto(newFeed: viewModel.selectedNews!)
            }
            
            // Loading view
            if viewModel.isLoadingNews {
                Loading()
            }
        }
        
    }
    
    func viewDidAppear() {
        print("view appear")
    }
}

struct NewsFeedView_Previews: PreviewProvider {
    static var previews: some View {
        NewsFeedView()
    }
}
