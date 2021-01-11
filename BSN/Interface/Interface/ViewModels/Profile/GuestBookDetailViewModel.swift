//
//  GuestBookDetailViewModel.swift
//  Interface
//
//  Created by Phucnh on 1/11/21.
//

import SwiftUI
import Business

class GuestBookDetailViewModel: NetworkViewModel {
    // Manage data for
    // View book detail of an user in guest mode
    
    @Published var model: BUserBook
    @Published var exchangeBook: BExchangeBook
    
    private var userbookManager: UserBookManager
    private var ebManager: ExchangeBookManager
    
    private var ubid: String
    
    override init() {
        model = BUserBook()
        exchangeBook = BExchangeBook()
        userbookManager = UserBookManager()
        ebManager = ExchangeBookManager()
        ubid = ""
        
        super.init()
        
        observerGetUserBook()
        observerExchangeBook()
    }
    
    func prepareData(ubid: String) {
        isLoading = true
        self.ubid = ubid
        userbookManager.getUserBook(ubid: ubid)
        ebManager.getNewestExchangeBookOfUB(ubid: ubid)
    }
    
    /// User Book get from server will received at this block
    private func observerGetUserBook() {
        /// Get user book by ID to load on UI
        userbookManager
            .getUserBookPublisher
            .sink {[weak self] (ub) in
                
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    self.isLoading = false
                    
                    if ub.id == "undefine" {
                        self.resourceInfo = .notfound
                        self.showAlert.toggle()
                    } else {
                        
                        self.model.id = ub.id
                        self.model.title = ub.title!
                        self.model.author = ub.author!
                        self.model.description = ub.description!
                        self.model.cover = ub.cover  ?? "book_cover"
                        self.model.statusDes = ub.statusDes!
                        self.model.state = ub.state.map { BookState(rawValue: $0)! }
                        self.model.status = ub.status.map { BookStatus(rawValue: $0)! }
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    private func observerExchangeBook() {
        ebManager
            .getExchangeBookPublisher
            .sink {[weak self] (eb) in
                
                guard let self = self else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.isLoading = false
                                        
                    if eb.id != kUndefine && eb.id != nil {
                        self.exchangeBook = BExchangeBook(
                            id: eb.id,
                            firstTitle: eb.firstTitle!,
                            firstAuthor: eb.firstAuthor!,
                            firstCover: eb.firstCover!,
                            partnerLocation: eb.location!,
                            sencondTitle: eb.secondTitle!,
                            secondAuthor: eb.secondAuthor!,
                            secondCover: eb.secondCover
                        )
                    }
                }
            }
            .store(in: &cancellables)
    }
}
