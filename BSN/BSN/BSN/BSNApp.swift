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
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @ObservedObject var appManager: AppManager = .shared
    
    var profileNavState: NavigationState = NavigationState()
    
    var exploreNavState: NavigationState = NavigationState()
    
    var body: some Scene {
        WindowGroup {
            if appManager.appState == .loading {
                Launching()
            } else if appManager.appState == .login {
                Login()
            } else if appManager.appState == .inapp {
                inapp
            }
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
    
    var inapp: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottomLeading) {
                // Main tab item
                TabView(selection: $appManager.selectedIndex) {
                    NavigationView {
                        NewsFeedView()
                            .navigationTitle("Bài viết")
                            .navigationBarHidden(true)
                    }
                    .tabItem { ItemContent(selectedIndex: $appManager.selectedIndex, type: .news) }
                    .tag(0)
                    
                    NavigationView {
                        ExploreBookView()
                            .navigationTitle("Khám phá")
                            .navigationBarHidden(true)
                            .environmentObject(exploreNavState)
                    }
                    .tabItem { ItemContent(selectedIndex: $appManager.selectedIndex, type: .search) }
                    .tag(1)
                    
                    NavigationView {
                        ChatView()
                            .navigationTitle("Tin nhắn")
                    }
                    .tabItem { ItemContent(selectedIndex: $appManager.selectedIndex, type: .chat) }
                    .tag(2)
                    
                    NavigationView {
                        NotifyView()
                            .navigationTitle("Thông báo")
                    }
                    .tabItem { ItemContent(selectedIndex: $appManager.selectedIndex, type: .notify) }
                    .tag(3)
                    
                    NavigationView {
                        ProfileView()
                            .navigationBarTitle(Text("Trang cá nhân"), displayMode: .inline)
                            .navigationBarHidden(true)
                            .environmentObject(profileNavState)
                    }
                    .tabItem { ItemContent(selectedIndex: $appManager.selectedIndex, type: .profile) }
                    .tag(4)
                }
                .environmentObject(appManager)
                
                // Badge
                BadgeView(type: .chat)
                    .offset(x: (geometry.size.width / 2) + 5, y: -25)
                
                BadgeView(type: .notify)
                    .offset(x: (geometry.size.width / 5) * 3.5, y: -25)
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
