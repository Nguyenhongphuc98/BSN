//
//  NotifyView.swift
//  Interface
//
//  Created by Phucnh on 10/1/20.
//

import SwiftUI

public struct NotifyView: View {
    
    @StateObject var viewModel: NotifyViewModel = NotifyViewModel.shared
    
    @EnvironmentObject var root: AppManager
    
    public init() { }
    
    public var body: some View {
        VStack {
            // Notify
            if viewModel.notifies.isEmpty {
                Text(viewModel.message)
                    .robotoItalic(size: 15)
            }
            
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
            
            if viewModel.isLoadmore {
                CircleLoading(frame: CGSize(width: 20, height: 20))
            }
        }
        .padding(.top)
        .embededLoadingFull(isLoading: $viewModel.isLoading)
        .onAppear(perform: viewAppeared)
    }
    
    func viewAppeared() {
        print("notifi appeared")
    }
}

struct NotifyView_Previews: PreviewProvider {
    static var previews: some View {
        NotifyView()
    }
}
