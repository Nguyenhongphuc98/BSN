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
    
    @ObservedObject var viewModel: RootViewModel = RootViewModel.shared
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                TabView(selection: $viewModel.selectedIndex) {
                    NewsFeedView()
                        .environmentObject(viewModel)
                        .tabItem { ItemContent(selectedIndex: $viewModel.selectedIndex, type: .news) }
                        .tag(0)
                    
                    ProfileView()
                        .tabItem { ItemContent(selectedIndex: $viewModel.selectedIndex, type: .search) }
                        .tag(1)
                    
                    ProfileView()
                        .tabItem { ItemContent(selectedIndex: $viewModel.selectedIndex, type: .chat) }
                        .tag(2)
                    
                    NotifyView()
                        .tabItem { ItemContent(selectedIndex: $viewModel.selectedIndex, type: .notify) }
                        .tag(3)
                    
                    ProfileView()
                        .tabItem { ItemContent(selectedIndex: $viewModel.selectedIndex, type: .profile) }
                        .tag(4)
                }
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
    
    func configureAppearance() {
        
        UITableView.appearance().backgroundColor = .white
        
        //let backImage = UIImage(named: "lauchlogo")
            //.withPadding(.init(top: -2, left: 0, bottom: 0, right: -4))
        
        //UINavigationBar.appearance().backIndicatorImage = backImage
        //UINavigationBar.appearance().backIndicatorTransitionMaskImage = backImage
        //UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().titleTextAttributes = [.font : UIFont(name: "Roboto-Bold", size: 13)!]
    }
}
