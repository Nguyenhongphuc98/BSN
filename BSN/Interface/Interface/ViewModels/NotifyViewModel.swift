//
//  NotifyViewModel.swift
//  Interface
//
//  Created by Phucnh on 10/1/20.
//

import SwiftUI
import Business

public class NotifyViewModel: NetworkViewModel {
    
    public static var shared: NotifyViewModel = NotifyViewModel()
    
    @Published var notifies: [Notify]
    
    @Published var message: String
    
    private var notifyManager: NotifyManager
    
    override init() {
        message = "Tạm thời chưa có thông báo"
        notifies = []
        notifyManager = NotifyManager()
        
        super.init()
        observerNotifies()
        prepareData()
    }
    
    public func prepareData() {
        print("did prepare data explore book VM")
        isLoading = true
        notifyManager.getNotifies(page: 0)
    }
    
    func loadMoreIfNeeded(item: Notify) {
        //get last index of fetched notifies
        let thresholdIndex = notifies.index(notifies.endIndex, offsetBy: -2)
        
        // if item reached is same threshold, we shoud load more
        if notifies.firstIndex(where: { $0.id == item.id }) == thresholdIndex {
            print("reached \(item.id)")
            self.isLoading = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                for _ in 1...7 {
//                    self.notifies.append(Notify())
//                }
                self.isLoading = false
                //print("total notifies: \(self.notifies.count)")
            }
        }
    }
    
    func notifyDidReaded(notify: Notify) {
        notify.seen = true
        // request to server
        notifyManager.updateNotify(notify: ENotify(id: notify.id, seen: true))
    }
    
    // receive data for first time
    private func observerNotifies() {
        notifyManager
            .getNotifiesPublisher
            .sink {[weak self] (notifies) in
                
                guard let self = self else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.notifies = []
                    
                    if !notifies.isEmpty {
                        if notifies[0].id == kUndefine {
                            self.message = "Có lỗi xảy ra khi tải dữ liệu!"
                        } else {
                            notifies.forEach { (n) in
                                let notify = Notify(enotify: n)
                                self.notifies.appendUnique(item: notify)
                            }
                        }
                    }
                }
            }
            .store(in: &cancellables)
    }
}
