//
//  Launching.swift
//  BSN
//
//  Created by Phucnh on 11/11/20.
//

import SwiftUI

struct Launching: View {
    
    @StateObject var viewModel: LaunchingViewModel = LaunchingViewModel()
    
    var body: some View {
        ProgressView("Đang tải", value: viewModel.progess, total: 1)
            .progressViewStyle(LinearProgressViewStyle())
            .padding(.horizontal)
    }
}

struct Launching_Previews: PreviewProvider {
    static var previews: some View {
        Launching()
    }
}
