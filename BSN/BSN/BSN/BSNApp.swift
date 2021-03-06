//
//  BSNApp.swift
//  BSN
//
//  Created by Phucnh on 9/21/20.
//

import SwiftUI
import Interface
import FBSDKCoreKit

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
                    .onOpenURL { (url) in
                        ApplicationDelegate.shared.application(UIApplication.shared, open: url, sourceApplication: nil, annotation: UIApplication.OpenURLOptionsKey.annotation)
                    }
            } else if appManager.appState == .onboard {
                PersonalizeView(onboard: true)
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
                            .navigationBarTitle(Text("Bài viết"))
                            .navigationBarHidden(true)
                    }
                    .tabItem { ItemContent(selectedIndex: $appManager.selectedIndex, type: .news) }
                    .tag(0)

                    NavigationView {
                        ExploreBookView()
                            .navigationBarTitle("", displayMode: .inline)
                            .navigationBarHidden(true)
                            .environmentObject(exploreNavState)
                    }
                    .navigationViewStyle(StackNavigationViewStyle())
                    .tabItem { ItemContent(selectedIndex: $appManager.selectedIndex, type: .search) }
                    .tag(1)

                    NavigationView {
                        ChatView()
                            .navigationBarTitle("Tin nhắn", displayMode: .large)
                    }
                    .tabItem { ItemContent(selectedIndex: $appManager.selectedIndex, type: .chat) }
                    .tag(2)

                    NavigationView {
                        NotifyView()
                            .navigationBarTitle("Thông báo", displayMode: .large)
                    }
                    .tabItem { ItemContent(selectedIndex: $appManager.selectedIndex, type: .notify) }
                    .tag(3)

                    NavigationView {
                        ProfileView(vm: ProfileViewModel.shared)
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
                    .offset(x: (geometry.size.width / 2) + 5, y: -28)

                BadgeView(type: .notify)
                    .offset(x: (geometry.size.width / 5) * 3.5, y: -28)
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
