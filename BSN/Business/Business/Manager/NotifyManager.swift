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
    
    // Observer new message come
    public let receiveNotifyPublisher: PassthroughSubject<ENotify, Never>
    private let webSocket: SocketFollow<ENotify>
    
    public init() {
        // Init resource URL
        networkRequest = NotifyRequest(componentPath: "notifies/")
        
        getNotifiesPublisher = PassthroughSubject<[ENotify], Never>()
        changeNotifyPublisher = PassthroughSubject<ENotify, Never>()
        
        // WebSocket
        receiveNotifyPublisher = PassthroughSubject<ENotify, Never>()
        webSocket = SocketFollow()
    }
    
    public func getNotifies(page: Int = 0, per: Int = BusinessConfigure.notifiesPerPage, regisgerID: String) {
        if page == 0 {
            // Setup receive data for first time fetch data
            webSocket.connect(url: wsNotifiesApi + regisgerID)
            webSocket.didReceiveData = { message in
                print("Business did receive new notify: \(message.notifyName!)")
                self.receiveNotifyPublisher.send(message)
            }
        }
        networkRequest.getNotifies(page: page, per: per, publisher: getNotifiesPublisher)
    }
    
    public func updateNotify(notify: ENotify) {
        networkRequest.updateNotify(notify: notify, publisher: changeNotifyPublisher)
    }
}
