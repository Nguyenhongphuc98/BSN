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
    
    @Published var model: BUserBook
    
    @Published var bookCode: String
    
    @Published var showAlert: Bool
    
    @Published var enableDoneBtn: Bool
    
    private var bookManager: BookManager
    
    private var bookID: String?
    
    //Cancellable
    var searchCancellables = Set<AnyCancellable>()
    
    init() {
        model = BUserBook()
        bookCode = ""
        bookManager = BookManager.shared
        showAlert = false
        enableDoneBtn = false
        
        setupReceiveBookInfo()
        model.description = ""
        model.statusDes = ""
        model.title = "Tiêu đề sách"
        model.author = "Tác giả"
    }
    
    func prepareData(bookID: String) {
        self.bookID = bookID
        bookManager.fetchBook(bookID: bookID)
    }
    
    func loadInfoFromGoogle() {
        bookManager.getBookInfo(by: bookCode)
    }
    
    func addBook(complete: @escaping (Bool) -> Void) {
        complete(true)
    }
    
    func updateBook(complete: @escaping (Bool) -> Void) {
        complete(true)
    }
    
    // Result book info from google api
    // Book get from server or google will received at this block
    func setupReceiveBookInfo() {
        print("Begin setup get book info receive")
        bookManager
            .bookPublisher
            .sink {[weak self] (book) in
                
                guard let self = self else {
                    return
                }
                
                DispatchQueue.main.async {
                    if book.id == "undefine" {
                        self.showAlert.toggle()
                    } else {
                        
                        self.model.title = book.title
                        self.model.author = book.author
                        self.model.description = book.description!
                        self.model.cover = book.cover
                        self.enableDoneBtn = true
                        print("did receive book info")
                    }
                }
            }
            .store(in: &searchCancellables)
        print("Finish setup get book info receive")
    }
}
