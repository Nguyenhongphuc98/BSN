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
    private var notifyManager: NotifyManager
    
    @Published var notifies: [Notify] {
        didSet {
            AppManager.shared.updateTabbar(notifies: notifies)
        }
    }
    
    @Published var message: String
    
    // Load more notifies
    @Published var isLoadmore: Bool
    @Published var allNotifiesFetched: Bool
    @Published var currentPage: Int
    
    override init() {
        message = "Tạm thời chưa có thông báo"
        notifies = []
        notifyManager = NotifyManager()
        isLoadmore = false
        allNotifiesFetched = false
        currentPage = 0
        
        super.init()
        observerNotifies()
        //prepareData() // Did call when login success.a
        ReceiveNewNotifies()
    }
    
    public func prepareData() {
        print("did prepare data notifies VM")
        isLoading = true
        notifies = []
        notifyManager.getNotifies(page: 0, regisgerID: AppManager.shared.currenUID)
    }
    
    func loadMoreIfNeeded(item: Notify) {
        guard !allNotifiesFetched else {
            print("All notifies fetched. break fetching func...")
            return
        }
        let thresholdIndex = notifies.count - 1
        if notifies.firstIndex(where: { $0.id == item.id }) == thresholdIndex {
            currentPage += 1
            isLoadmore = true
            notifyManager.getNotifies(page: currentPage, regisgerID: AppManager.shared.currenUID)
        }
    }
    
    func notifyDidReaded(notify: Notify) {
        // Mark as seen
        notify.seen = true
        // Force update num unread notifies for tabbar
        AppManager.shared.updateTabbar(notifies: self.notifies)
        // request to server
        notifyManager.updateNotify(notify: ENotify(id: notify.id, seen: true))
    }
    
    // receive data for by page
    private func observerNotifies() {
        notifyManager
            .getNotifiesPublisher
            .sink {[weak self] (notifies) in
                
                guard let self = self else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.isLoadmore = false
                    
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
                    
                    // num of news < config shoud be last page
                    if notifies.count < BusinessConfigure.notifiesPerPage {
                        self.allNotifiesFetched = true
                    }
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - WebSocket
extension NotifyViewModel {
    private func ReceiveNewNotifies() {
        notifyManager
            .receiveNotifyPublisher
            .sink {[weak self] (n) in
                
                guard let self = self else {
                    return
                }
                
                DispatchQueue.main.async {
                    let notify = Notify(enotify: n)
                    self.notifies.insertUnique(item: notify)
                }
            }
            .store(in: &cancellables)
    }
}
