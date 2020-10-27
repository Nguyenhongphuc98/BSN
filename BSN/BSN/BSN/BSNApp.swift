//
//  BSNApp.swift
//  BSN
//
//  Created by Phucnh on 9/21/20.
//

import SwiftUI
import Interface

@main
struct BSNApp: App {
    
    @Environment(\.scenePhase) private var phase
    
    @ObservedObject var viewModel: AppManager = AppManager.shared
    
    var body: some Scene {
        WindowGroup {
            TabView(selection: $viewModel.selectedIndex) {
                NavigationView {
                    NewsFeedView()
                        .navigationTitle("Bài viết")
                        .navigationBarHidden(true)
                }
                .tabItem { ItemContent(selectedIndex: $viewModel.selectedIndex, type: .news) }
                .tag(0)
                
                NavigationView {
                    SearchView()
                        .navigationTitle("Khám phá")
                        .navigationBarHidden(true)
                }
                .tabItem { ItemContent(selectedIndex: $viewModel.selectedIndex, type: .search) }
                .tag(1)
                
                NavigationView {
                    ChatView()
                        .navigationTitle("Tin nhắn")
                }
                .tabItem { ItemContent(selectedIndex: $viewModel.selectedIndex, type: .chat) }
                .tag(2)
                
                NavigationView {
                    NotifyView()
                        .navigationTitle("Thông báo")
                }
                .tabItem { ItemContent(selectedIndex: $viewModel.selectedIndex, type: .notify) }
                .tag(3)
                
                NavigationView {
                    ProfileView()
                        .navigationBarTitle(Text("Trang cá nhân"), displayMode: .inline)
                        .navigationBarHidden(true)
                }
                .tabItem { ItemContent(selectedIndex: $viewModel.selectedIndex, type: .profile) }
                .tag(4)
            }
            .environmentObject(viewModel)
        }
        .onChange(of: phase) { newPhase in
            switch newPhase {
            case .active:
                print("App became active")
                configureAppearance()
            case .inactive:
                print("App became inactive")
            case .background:
                print("App is running in the background")
            @unknown default:
                print("Fallback for future cases")
            }
        }
    }
    
    func configureAppearance() {
        
        UITextView.appearance().backgroundColor = .clear
        
        UITableView.appearance().backgroundColor = .clear
        
        //let backImage = UIImage(named: "lauchlogo")
        //.withPadding(.init(top: -2, left: 0, bottom: 0, right: -4))
        
        //UINavigationBar.appearance().backIndicatorImage = backImage
        //UINavigationBar.appearance().backIndicatorTransitionMaskImage = backImage
        //UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().titleTextAttributes = [.font : UIFont(name: "Roboto-Bold", size: 13)!]
    }
}
