//
//  NetworkViewModel.swift
//  Interface
//
//  Created by Phucnh on 10/30/20.
//

import Combine

class NetworkViewModel: ObservableObject {
    
    @Published var isLoading: Bool
    
    @Published var showAlert: Bool
    
    var cancellables = Set<AnyCancellable>()
    
    // Handle result process resource
    var resourceInfo: ResourceInfo
    
    init() {
        isLoading = false
        showAlert = false
        resourceInfo = .success
    }
}
