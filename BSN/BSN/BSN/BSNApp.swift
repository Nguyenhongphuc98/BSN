//
//  BSNApp.swift
//  BSN
//
//  Created by Phucnh on 9/21/20.
//

import SwiftUI
import Interface
import Component

@main
struct BSNApp: App {
    
    @Environment(\.scenePhase) private var phase
    
    @ObservedObject var viewModel: RootViewModel = RootViewModel.shared
    
    var body: some Scene {
        WindowGroup {
            TabView(selection: $viewModel.selectedIndex) {
                ProfileView()
                    .tabItem { ItemContent(selectedIndex: $viewModel.selectedIndex, type: .news) }
                    .tag(0)
                
                ProfileView()
                    .tabItem { ItemContent(selectedIndex: $viewModel.selectedIndex, type: .search) }
                    .tag(1)

                ProfileView()
                    .tabItem { ItemContent(selectedIndex: $viewModel.selectedIndex, type: .chat) }
                    .tag(2)

                ProfileView()
                    .tabItem { ItemContent(selectedIndex: $viewModel.selectedIndex, type: .notify) }
                    .tag(3)

                ProfileView()
                    .tabItem { ItemContent(selectedIndex: $viewModel.selectedIndex, type: .profile) }
                    .tag(4)
            }
        }
        .onChange(of: phase) { newPhase in
            switch newPhase {
            case .active:
                print("App became active")
            case .inactive:
                print("App became inactive")
            case .background:
                print("App is running in the background")
            @unknown default:
                print("Fallback for future cases")
            }
        }
    }
}
