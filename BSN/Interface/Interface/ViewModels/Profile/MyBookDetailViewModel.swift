//
//  MyBookDetailViewModel.swift
//  Interface
//
//  Created by Phucnh on 10/10/20.
//

import SwiftUI
import Business

class MyBookDetailViewModel: NetworkViewModel {
    
    @Published var model: BUserBook
    
    @Published var notes: [Note]
    
    private var userbookManager: UserBookManager
    
    override init() {
        model = BUserBook()
        notes = [Note(), Note()]
        userbookManager = UserBookManager.shared
        
        super.init()
        
        setupReceiveBookInfo()
    }
    
    func prepareData(ubid: String) {
        isLoading = true
        userbookManager.getUserBook(ubid: ubid)
    }
    
    func addNewNote(content: String, complete: @escaping (Bool) -> Void) {
        notes.append(Note(content: content))
        complete(true)
    }
    
    /// Book get from server or google will received at this block
    private func setupReceiveBookInfo() {
        /// Get user book by ID to load on UI
        userbookManager
            .getUserBookPublisher
            .sink {[weak self] (ub) in
                
                guard let self = self else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.isLoading = false
                    
                    if ub.id == "undefine" {
                        self.resourceInfo = .notfound
                        self.showAlert.toggle()
                    } else {
                        
                        self.model.title = ub.title!
                        self.model.author = ub.author!
                        self.model.description = ub.description!
                        self.model.cover = ub.cover
                        self.model.statusDes = ub.statusDes!
                    }
                }
            }
            .store(in: &cancellables)
    }
}
