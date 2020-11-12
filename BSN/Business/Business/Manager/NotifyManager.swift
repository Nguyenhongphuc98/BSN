//
//  NotifyManager.swift
//  Business
//
//  Created by Phucnh on 11/12/20.
//
import Combine

public class NotifyManager {
    
    private let networkRequest: NotifyRequest
    
    // Publisher for fetch notifies of current user in session
    public let getNotifiesPublisher: PassthroughSubject<[ENotify], Never>
    
    public let changeNotifyPublisher: PassthroughSubject<ENotify, Never>
    
    public init() {
        // Init resource URL
        networkRequest = NotifyRequest(componentPath: "notifies/")
        
        getNotifiesPublisher = PassthroughSubject<[ENotify], Never>()
        changeNotifyPublisher = PassthroughSubject<ENotify, Never>()
    }
    
    public func getNotifies(page: Int = 0, per: Int = BusinessConfigure.notifiesPerPage) {
        networkRequest.getNotifies(page: page, per: per, publisher: getNotifiesPublisher)
    }
    
    public func updateNotify(notify: ENotify) {
        networkRequest.updateNotify(notify: notify, publisher: changeNotifyPublisher)
    }
}
