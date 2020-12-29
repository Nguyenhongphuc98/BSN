//
//  HistoryView.swift
//  Interface
//
//  Created by Phucnh on 12/17/20.
//

import SwiftUI

struct HistoryView: View {
    
    @State private var selectedSegment = 0
    @StateObject var viewModel: HistoryViewModel = .init()
    
    var body: some View {
        VStack {
            Picker(selection: $selectedSegment, label: Text("What kind of history you want to show?")) {
                Text("Mượn").tag(0)
                Text("Trao đổi").tag(1)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            TabView(
                selection: $selectedSegment,
                content:  {
                    borrow.tag(0)                    
                    exchange.tag(1)
                })
                .tabViewStyle(PageTabViewStyle())
                .embededLoadingFull(isLoading: $viewModel.isLoading)
        }
    }
    
    private var borrow: some View {
        ScrollView {
            if viewModel.borrowModels.isEmpty {
                Text("Chưa có lịch sử mượn sách")
                    .robotoLightItalic(size: 13)
                    .padding()
            } else {
                LazyVStack {
                    ForEach(viewModel.borrowModels) { item in
                        HistoryCard(model: item)
                    }
                }
            }
        }
    }
    
    private var exchange: some View {
        ScrollView {
            if viewModel.borrowModels.isEmpty {
                Text("Chưa có lịch sử đổi sách")
                    .robotoLightItalic(size: 13)
                    .padding()
            } else {
                LazyVStack {
                    ForEach(viewModel.exchangeModels) { item in
                        HistoryCard(model: item)
                    }
                }
            }
        }
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
