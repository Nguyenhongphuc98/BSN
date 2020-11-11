//
//  NetworkViewModel.swift
//  Interface
//
//  Created by Phucnh on 10/30/20.
//

import Combine

open class NetworkViewModel: ObservableObject {
    
    @Published open var isLoading: Bool
    
    @Published open var showAlert: Bool
    
    open var cancellables = Set<AnyCancellable>()
    
    // Handle result process resource
    open var resourceInfo: ResourceInfo
    
    public init() {
        isLoading = false
        showAlert = false
        resourceInfo = .success
    }
}
