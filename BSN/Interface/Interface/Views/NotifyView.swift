//
//  NotifyView.swift
//  Interface
//
//  Created by Phucnh on 10/1/20.
//

import SwiftUI

public struct NotifyView: View {
    
    @StateObject var viewModel: NotifyViewModel = NotifyViewModel()
    
    public init() {
        
    }
    
    public var body: some View {
        VStack {
            // Notify
            List {
                ForEach(viewModel.notifies) { notify in
                    VStack {
                        NotifyCard(model: notify)
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
        .navigationTitle("Notify")
        .navigationBarHidden(true)
    }
}

struct NotifyView_Previews: PreviewProvider {
    static var previews: some View {
        NotifyView()
    }
}
