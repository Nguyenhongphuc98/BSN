//
//  NotifyViewModel.swift
//  Interface
//
//  Created by Phucnh on 10/1/20.
//

import SwiftUI

class NotifyViewModel: ObservableObject {
    
    // Loading new news when sroll to last news
    @Published  var isLoading: Bool
    
    @Published var notifies: [Notify]
    
    init() {
        isLoading = false
        notifies = fakeNotifies
    }
    
    func loadMoreIfNeeded(item: Notify) {
        let thresholdIndex = notifies.index(notifies.endIndex, offsetBy: -2)
        if notifies.firstIndex(where: { $0.id == item.id }) == thresholdIndex {
            print("reached \(item.id)")
            self.isLoading = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                for _ in 1...7 {
                    self.notifies.append(Notify())
                }
                self.isLoading = false
                print("total notifies: \(self.notifies.count)")
            }
        }
    }
}
