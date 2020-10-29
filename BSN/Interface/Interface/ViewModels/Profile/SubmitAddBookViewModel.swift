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
    
    @Published var isbn: String
    
    @Published var showAlert: Bool
    
    @Published var enableDoneBtn: Bool
    
    private var bookManager: BookManager
    
    private var bookID: String?
    
    // Handle reslut process resource
    var resourceInfo: ResourceInfo
    
    //Cancellable
    var searchCancellables = Set<AnyCancellable>()
    
    init() {
        model = BUserBook()
        isbn = ""
        bookManager = BookManager.shared
        showAlert = false
        enableDoneBtn = false
        resourceInfo = .success
        
        setupReceiveBookInfo()
        setupReceiveSaveBookInfo()
    }
    
    func prepareData(bookID: String) {
        self.bookID = bookID
        bookManager.fetchBook(bookID: bookID)
    }
    
    func loadInfoFromGoogle() {
        bookManager.getBookInfo(by: isbn)
    }
    
    // Add new book to book system
    func addBook(complete: @escaping (Bool) -> Void) {
        let newBook = Book(
            title: model.title,
            author: model.author,
            isbn: isbn,
            cover: model.cover,
            des: model.description
        )
        
        bookManager.saveBook(book: newBook)
        complete(true)
    }
    
    func addUserBook(complete: @escaping (Bool) -> Void) {
        complete(true)
    }
    
    func updateUserBook(complete: @escaping (Bool) -> Void) {
        complete(true)
    }
    
    // Result book info from google api
    // Book get from server or google will received at this block
    func setupReceiveBookInfo() {
        print("Begin setup get book info receive")
        bookManager
            .getBookPublisher
            .sink {[weak self] (book) in
                
                guard let self = self else {
                    return
                }
                
                DispatchQueue.main.async {
                    if book.id == "undefine" {
                        self.resourceInfo = .notfound
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
    
    func setupReceiveSaveBookInfo() {
        print("Begin setup get book info receive")
        bookManager
            .saveBookPublisher
            .sink {[weak self] (book) in
                
                guard let self = self else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.showAlert.toggle()
                    if book.id == "undefine" {
                        self.resourceInfo = .exists
                    } else {
                        self.resourceInfo = .success
                    }
                    print("did receive book info")
                }
            }
            .store(in: &searchCancellables)
        print("Finish setup get book info receive")
    }
}
