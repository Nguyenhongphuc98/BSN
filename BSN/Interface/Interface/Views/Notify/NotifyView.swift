//
//  NotifyView.swift
//  Interface
//
//  Created by Phucnh on 10/1/20.
//

import SwiftUI

public struct NotifyView: View {
    
    @StateObject var viewModel: NotifyViewModel = NotifyViewModel()
    
    @EnvironmentObject var root: RootViewModel
    
    public init() {
        
    }
    
    public var body: some View {
        VStack {
            // Notify
            List {
                ForEach(viewModel.notifies) { notify in
                    VStack {
                        NotifyCard(model: notify)
                            .environmentObject(viewModel)
                        .onAppear(perform: {
                            self.viewModel.loadMoreIfNeeded(item: notify)
                        })
                        
                        Separator(height: 1)
                    }
                }
                .listRowInsets(.zero)
                .listRowBackground(Color.white)
            }
            
            if viewModel.isLoading {
                Loading()
            }
        }
        .padding(.top)
        //.navigationTitle("Notify")
        //.navigationBarHidden(true)
        .onAppear(perform: viewAppeared)
    }
    
    func viewAppeared() {
        if root.selectedIndex == RootIndex.notify.rawValue {
            root.navBarTitle = "Thông báo"
            root.navBarHidden = true
        }
        
        print("notifi appeared")
    }
}

struct NotifyView_Previews: PreviewProvider {
    static var previews: some View {
        NotifyView()
    }
}
