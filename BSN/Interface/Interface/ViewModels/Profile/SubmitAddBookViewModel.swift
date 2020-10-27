//
//  SubmitAddBookViewModel.swift
//  Interface
//
//  Created by Phucnh on 10/11/20.
//

import SwiftUI
import Business
import Combine

class SubmitAddBookViewModel: ObservableObject {
    
    @Published var model: MyBookDetail
    
    @Published var bookCode: String
    
    private var bookManager: BookManager
    
    //Cancellable
    var searchCancellables = Set<AnyCancellable>()
    
    init() {
        model = MyBookDetail()
        bookCode = "XBDFS"
        bookManager = BookManager.shared
        setupReceiveBookInfo()
    }
    
    func loadInfo() {
        bookManager.getBookInfo(by: bookCode)
    }
    
    func addBook(complete: @escaping (Bool) -> Void) {
        complete(true)
    }
    
    func updateBook(complete: @escaping (Bool) -> Void) {
        complete(true)
    }
    
    // Result book info from google api
    func setupReceiveBookInfo() {
        print("Begin setup get book info receive")
        bookManager
            .googleBookPublisher
            .sink {[weak self] (book) in
                
                guard let self = self else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.model.name = book.title
                    self.model.author = book.author
                    self.model.description = book.description!
                }
            }
            .store(in: &searchCancellables)
        print("Finish setup get book info receive")
    }
}
